"""
Qwen QLoRA微调直接脚本
宇宙本论 v37.5
无需axolotl，直接使用transformers和peft库
"""

import os
import json
import torch
import logging
import yaml
from datasets import load_dataset
from transformers import (
    AutoModelForCausalLM,
    AutoTokenizer,
    BitsAndBytesConfig,
    TrainingArguments,
    DataCollatorForSeq2Seq,
    Trainer,
)
from peft import LoraConfig, get_peft_model, prepare_model_for_kbit_training
from typing import List, Dict, Any

# 设置日志
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# 从环境变量获取配置路径，如果不存在则使用默认值
config_path = os.environ.get("AXOLOTL_CONFIG_PATH", "../config.yaml")
logger.info(f"使用配置文件: {config_path}")

# 读取配置文件
try:
    with open(config_path, 'r', encoding='utf-8') as f:
        config = yaml.safe_load(f)
    logger.info("成功加载配置文件")
except Exception as e:
    logger.warning(f"无法加载配置文件: {e}, 使用默认配置")
    config = {}

# 配置参数 - 优先使用环境变量，然后是配置文件，最后是默认值
MODEL_NAME = config.get("base_model", "Qwen/Qwen-1_8B-Chat")
DATA_PATH = os.environ.get("DATA_DIR", config.get("datasets", [{"path": "../data/cosmos_ontology.jsonl"}])[0]["path"])
OUTPUT_DIR = os.environ.get("MODEL_OUTPUT_DIR", config.get("output_dir", "../output/qwen-qlora-direct"))
MICRO_BATCH_SIZE = int(config.get("micro_batch_size", 4))
GRADIENT_ACCUMULATION_STEPS = int(config.get("gradient_accumulation_steps", 8))
LEARNING_RATE = float(config.get("learning_rate", 2e-4))
NUM_EPOCHS = int(config.get("train", {}).get("num_train_epochs", 3))
MAX_SEQ_LENGTH = int(config.get("max_seq_length", 512))

# 打印主要配置
logger.info(f"模型: {MODEL_NAME}")
logger.info(f"数据路径: {DATA_PATH}")
logger.info(f"输出目录: {OUTPUT_DIR}")
logger.info(f"批次大小: {MICRO_BATCH_SIZE}")
logger.info(f"梯度累积步数: {GRADIENT_ACCUMULATION_STEPS}")
logger.info(f"学习率: {LEARNING_RATE}")
logger.info(f"训练轮次: {NUM_EPOCHS}")

def load_jsonl_data(file_path: str) -> List[Dict[str, Any]]:
    """加载JSONL格式的数据"""
    with open(file_path, 'r', encoding='utf-8') as f:
        return [json.loads(line) for line in f]

def prepare_alpaca_format(examples):
    """准备Alpaca格式的数据"""
    conversations = []
    
    for example in examples:
        conversation = {
            "system": example.get("system", ""),
            "instruction": example.get("instruction", ""),
            "input": example.get("input", ""),
            "output": example.get("output", "")
        }
        conversations.append(conversation)
    
    return conversations

def tokenize_function(examples, tokenizer, max_length=MAX_SEQ_LENGTH):
    """将对话转换为模型输入格式并进行tokenize"""
    prompt_template = """<|im_start|>system
{system}<|im_end|>
<|im_start|>user
{instruction}{input_text}<|im_end|>
<|im_start|>assistant
{output}<|im_end|>"""

    # 构建提示语
    prompts = []
    for i in range(len(examples["system"])):
        input_text = f"\n{examples['input'][i]}" if examples["input"][i] else ""
        prompt = prompt_template.format(
            system=examples["system"][i],
            instruction=examples["instruction"][i],
            input_text=input_text,
            output=examples["output"][i]
        )
        prompts.append(prompt)

    # 确保tokenizer有padding token
    if tokenizer.pad_token is None:
        tokenizer.pad_token = tokenizer.eos_token
    
    # 进行tokenization
    tokenized = tokenizer(
        prompts,
        truncation=True,
        max_length=max_length,
        return_tensors="pt"
    )
    
    # 手动padding
    input_ids = tokenized["input_ids"]
    attention_mask = tokenized["attention_mask"]
    
    # 计算最大长度
    max_len = max([len(ids) for ids in input_ids])
    max_len = min(max_len, max_length)
    
    # 手动进行padding
    padded_input_ids = []
    padded_attention_mask = []
    
    for ids, mask in zip(input_ids, attention_mask):
        # 计算padding数量
        padding_length = max_len - len(ids)
        if padding_length > 0:
            # 添加padding
            padded_ids = torch.cat([ids, torch.tensor([tokenizer.pad_token_id] * padding_length)], dim=0)
            padded_mask = torch.cat([mask, torch.zeros(padding_length)], dim=0)
        else:
            padded_ids = ids[:max_len]
            padded_mask = mask[:max_len]
        
        padded_input_ids.append(padded_ids)
        padded_attention_mask.append(padded_mask)
    
    # 转换回tensor
    tokenized["input_ids"] = torch.stack(padded_input_ids)
    tokenized["attention_mask"] = torch.stack(padded_attention_mask)
    
    # 设置labels与input_ids相同，用于计算生成损失
    tokenized["labels"] = tokenized["input_ids"].clone()
    
    # 将padding位置的标签设置为-100，这样它们不会计入损失
    tokenized["labels"][tokenized["attention_mask"] == 0] = -100
    
    return tokenized

def main():
    logger.info("加载模型和tokenizer...")
    
    # 设置BitsAndBytes配置（QLoRA的4位量化）
    bnb_config = BitsAndBytesConfig(
        load_in_4bit=True,
        bnb_4bit_quant_type="nf4",
        bnb_4bit_compute_dtype=torch.float16,
        bnb_4bit_use_double_quant=True,
    )
    
    # 加载模型和tokenizer
    model = AutoModelForCausalLM.from_pretrained(
        MODEL_NAME, 
        quantization_config=bnb_config,
        device_map="auto",
        trust_remote_code=True
    )
    
    tokenizer = AutoTokenizer.from_pretrained(
        MODEL_NAME, 
        trust_remote_code=True
    )
    
    # 设置padding token
    if tokenizer.pad_token is None:
        logger.info("设置padding token为eos token")
        tokenizer.pad_token = tokenizer.eos_token
    
    # 确保pad_token_id不为None
    if tokenizer.pad_token_id is None:
        logger.info(f"pad_token_id为None，设置为固定值: 151643")
        # 使用Qwen的eos token id
        tokenizer.pad_token_id = 151643
    
    # 准备模型进行kbit训练
    model = prepare_model_for_kbit_training(model)
    
    # 从配置文件获取LoRA参数（如果存在）
    lora_config_dict = config.get("lora", {})
    lora_config = LoraConfig(
        r=lora_config_dict.get("r", 64),
        lora_alpha=lora_config_dict.get("alpha", 16),
        lora_dropout=lora_config_dict.get("dropout", 0.05),
        target_modules=lora_config_dict.get("target_modules", ["q_proj", "v_proj"]),
        bias=lora_config_dict.get("bias", "none"),
        task_type=lora_config_dict.get("task_type", "CAUSAL_LM")
    )
    
    # 应用LoRA配置到模型
    model = get_peft_model(model, lora_config)
    
    # 打印模型可训练参数
    model.print_trainable_parameters()
    
    # 加载数据集
    logger.info(f"加载数据集: {DATA_PATH}")
    try:
        # 尝试使用datasets库加载JSONL文件
        raw_dataset = load_dataset("json", data_files={"train": DATA_PATH})["train"]
        
        # 准备数据，直接处理而不是用map
        all_input_ids = []
        all_attention_masks = []
        all_labels = []
        
        # 设置padding token
        if tokenizer.pad_token is None:
            logger.info("设置padding token为eos token")
            tokenizer.pad_token = tokenizer.eos_token
        
        # 确保pad_token_id不为None
        if tokenizer.pad_token_id is None:
            logger.info(f"pad_token_id为None，设置为固定值: 151643")
            # 使用Qwen的eos token id
            tokenizer.pad_token_id = 151643
        
        # 处理每个样本
        for i in range(len(raw_dataset)):
            example = raw_dataset[i]
            # 构建提示
            input_text = f"\n{example['input']}" if example.get('input', '') else ""
            prompt = f"""<|im_start|>system
{example.get('system', '')}<|im_end|>
<|im_start|>user
{example.get('instruction', '')}{input_text}<|im_end|>
<|im_start|>assistant
{example.get('output', '')}<|im_end|>"""
            
            # Tokenize
            encoded = tokenizer(
                prompt,
                truncation=True,
                max_length=MAX_SEQ_LENGTH,
                return_tensors="pt"
            )
            
            input_ids = encoded["input_ids"][0]
            attention_mask = encoded["attention_mask"][0]
            
            # 创建标签（复制input_ids）
            labels = input_ids.clone()
            
            all_input_ids.append(input_ids)
            all_attention_masks.append(attention_mask)
            all_labels.append(labels)
        
        # 计算最大长度，用于padding
        max_length = max(len(ids) for ids in all_input_ids)
        logger.info(f"最大序列长度: {max_length}")
        
        # Padding
        padded_input_ids = []
        padded_attention_masks = []
        padded_labels = []
        
        for input_ids, attention_mask, labels in zip(all_input_ids, all_attention_masks, all_labels):
            padding_length = max_length - len(input_ids)
            if padding_length > 0:
                # 确保pad_token_id不为None
                pad_token_id = tokenizer.pad_token_id if tokenizer.pad_token_id is not None else 151643
                logger.info(f"使用pad_token_id: {pad_token_id}")
                
                # Padding input_ids
                input_ids = torch.cat([
                    input_ids, 
                    torch.ones(padding_length, dtype=torch.long) * pad_token_id
                ])
                # Padding attention_mask
                attention_mask = torch.cat([
                    attention_mask, 
                    torch.zeros(padding_length, dtype=torch.long)
                ])
                # Padding labels
                padded_label = torch.cat([
                    labels, 
                    torch.ones(padding_length, dtype=torch.long) * -100  # 忽略padding位置的损失
                ])
            else:
                padded_label = labels
            
            padded_input_ids.append(input_ids)
            padded_attention_masks.append(attention_mask)
            padded_labels.append(padded_label)
        
        # 创建数据集
        dataset_dict = {
            "input_ids": [tensor.tolist() for tensor in padded_input_ids],
            "attention_mask": [tensor.tolist() for tensor in padded_attention_masks],
            "labels": [tensor.tolist() for tensor in padded_labels]
        }
        
        from datasets import Dataset
        tokenized_dataset = Dataset.from_dict(dataset_dict)
        logger.info(f"数据集准备完成，共{len(tokenized_dataset)}个样本")
        
    except Exception as e:
        logger.error(f"处理数据集时出错: {e}")
        raise
    
    # 从配置文件获取训练参数
    train_config = config.get("train", {})
    
    # 定义训练参数
    training_args = TrainingArguments(
        output_dir=OUTPUT_DIR,
        per_device_train_batch_size=MICRO_BATCH_SIZE,
        gradient_accumulation_steps=GRADIENT_ACCUMULATION_STEPS,
        learning_rate=float(LEARNING_RATE),
        num_train_epochs=NUM_EPOCHS,
        weight_decay=float(train_config.get("weight_decay", 0.0)),
        warmup_steps=int(train_config.get("warmup_steps", 100)),
        logging_steps=int(train_config.get("logging_steps", 10)),
        save_steps=int(train_config.get("save_steps", 100)),
        fp16=bool(train_config.get("fp16", False)),
        bf16=bool(train_config.get("bf16", False)),
        optim=train_config.get("optim", "adamw_torch"),
        lr_scheduler_type=train_config.get("lr_scheduler_type", "cosine"),
        seed=int(train_config.get("seed", 42)),
        report_to=config.get("report_to", ["none"]),
    )
    
    # 创建Trainer
    trainer = Trainer(
        model=model,
        args=training_args,
        train_dataset=tokenized_dataset,
        data_collator=DataCollatorForSeq2Seq(tokenizer=tokenizer, padding=True),
    )
    
    # 开始训练
    logger.info("开始训练...")
    trainer.train()
    
    # 保存模型
    logger.info(f"保存模型到: {OUTPUT_DIR}")
    trainer.save_model(OUTPUT_DIR)
    
    logger.info("训练完成！")

if __name__ == "__main__":
    main() 