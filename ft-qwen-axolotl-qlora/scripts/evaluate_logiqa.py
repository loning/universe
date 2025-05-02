"""
Qwen微调模型LogiQA评估脚本
宇宙本论 v37.5
"""

import os
import torch
import argparse
import logging
import json
import re
import numpy as np
from tqdm import tqdm
from transformers import AutoModelForCausalLM, AutoTokenizer, BitsAndBytesConfig
from peft import PeftModel

# 设置日志记录
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def parse_arguments():
    parser = argparse.ArgumentParser(description="Qwen微调模型LogiQA评估脚本")
    parser.add_argument("--model_path", type=str, default="../output/qwen-qlora-ft/checkpoint-3",
                      help="微调模型路径")
    parser.add_argument("--base_model", type=str, default="Qwen/Qwen-1_8B-Chat",
                      help="基础模型名称")
    parser.add_argument("--data_path", type=str, default="../data/logiqa_test.jsonl",
                      help="LogiQA数据集路径")
    parser.add_argument("--output_path", type=str, default="../output/logiqa_results.json",
                      help="评估结果输出路径")
    parser.add_argument("--device", type=str, default="auto",
                      help="设备: auto, cpu, cuda, cuda:0, etc.")
    parser.add_argument("--use_4bit", action="store_true",
                      help="使用4bit量化加载模型")
    parser.add_argument("--max_samples", type=int, default=None,
                      help="最大评估样本数，默认评估全部")
    return parser.parse_args()

def load_logiqa_data(file_path):
    """加载LogiQA数据集"""
    if not os.path.exists(file_path):
        logger.error(f"LogiQA数据文件不存在: {file_path}")
        return []
    
    try:
        data = []
        with open(file_path, 'r', encoding='utf-8') as f:
            for line in f:
                item = json.loads(line.strip())
                # 将数字答案转换为字母选项 (0->A, 1->B, 2->C, 3->D)
                if "answer" in item:
                    answer_idx = item["answer"]
                    item["label"] = chr(65 + answer_idx)  # 将数字索引转换为A、B、C、D
                data.append(item)
        logger.info(f"成功加载LogiQA数据: {len(data)}条")
        return data
    except Exception as e:
        logger.error(f"加载LogiQA数据失败: {e}")
        return []

def extract_answer(text):
    """从模型输出中提取答案选项(A/B/C/D)"""
    # 尝试几种可能的提取模式
    patterns = [
        r'答案[是为选择]?\s*[：:]\s*([ABCD])',  # 中文格式：答案是/为/选择：A
        r'[Tt]he\s+[Aa]nswer\s+is\s+([ABCD])',  # 英文格式：The answer is A
        r'[Mm]y\s+[Aa]nswer\s+is\s+([ABCD])',   # 英文格式：My answer is A
        r'选项\s*([ABCD])',                      # 中文格式：选项A
        r'[Oo]ption\s+([ABCD])',                # 英文格式：Option A
        r'[选择]?\s*([ABCD])[选项]?',            # 简单格式：选/选择 A 选项
        r'答案[是为]?\s*([ABCD])',               # 简单中文：答案是A
        r'([ABCD])\s*是正确[的答案]',           # 中文格式：A是正确的答案
        r'([ABCD])[.。)]',                       # 简单格式：A.
        r'\s([ABCD])[\s,，.。:：]',              # 空格开头的选项：空格A空格/逗号/句号
        r'[^\w]([ABCD])$'                       # 行尾单独的选项
    ]
    
    for pattern in patterns:
        match = re.search(pattern, text)
        if match:
            return match.group(1).upper()
    
    # 如果没有找到结构化的答案，查找最后一次出现的选项
    all_options = re.findall(r'[ABCD]', text)
    if all_options:
        return all_options[-1].upper()
    
    # 如果实在找不到，默认返回第一个选项
    return "A"

def prepare_prompt(question, context, options):
    """准备LogiQA的提示格式"""
    # 构建选项文本
    options_text = ""
    for i, option in enumerate(options):
        option_letter = chr(65 + i)  # A, B, C, D
        options_text += f"{option_letter}. {option}\n"
    
    # 构建提示
    prompt = f"""请根据以下背景和问题，从给出的选项中选择一个最合适的答案。
背景：{context}
问题：{question}
选项：
{options_text}
你的任务是分析背景与问题，进行逻辑推理，然后从选项A、B、C、D中选择一个最合适的答案。
请直接给出答案选项（A/B/C/D）。
答案是："""
    
    # 完整提示格式化为Qwen模型要求格式
    formatted_prompt = f"<|im_start|>user\n{prompt}<|im_end|>\n<|im_start|>assistant\n"
    return formatted_prompt

def evaluate_model(args):
    """加载和评估微调模型"""
    # 加载LogiQA数据
    logiqa_data = load_logiqa_data(args.data_path)
    if not logiqa_data:
        return
    
    # 限制评估样本数
    if args.max_samples and args.max_samples < len(logiqa_data):
        logiqa_data = logiqa_data[:args.max_samples]
        logger.info(f"限制评估样本数为: {args.max_samples}")
    
    logger.info(f"开始评估，共{len(logiqa_data)}个样本")
    
    # 配置设备
    device_map = args.device if args.device != "auto" else "auto"
    
    # 量化配置
    if args.use_4bit:
        logger.info("使用4-bit量化加载模型")
        quantization_config = BitsAndBytesConfig(
            load_in_4bit=True,
            bnb_4bit_compute_dtype=torch.float16,
            bnb_4bit_quant_type="nf4",
            bnb_4bit_use_double_quant=True,
        )
    else:
        quantization_config = None
    
    # 加载基础模型和tokenizer
    logger.info(f"加载基础模型: {args.base_model}")
    model = AutoModelForCausalLM.from_pretrained(
        args.base_model,
        device_map=device_map,
        trust_remote_code=True,
        quantization_config=quantization_config,
    )
    
    tokenizer = AutoTokenizer.from_pretrained(
        args.base_model,
        trust_remote_code=True
    )
    
    # 确保tokenizer有padding token
    if tokenizer.pad_token is None:
        tokenizer.pad_token = tokenizer.eos_token
    
    # 加载微调的adapter
    logger.info(f"加载微调的adapter: {args.model_path}")
    model = PeftModel.from_pretrained(model, args.model_path)
    
    # 开始评估
    results = []
    correct_count = 0
    
    for idx, item in enumerate(tqdm(logiqa_data, desc="评估进度")):
        try:
            # 准备输入
            context = item.get("text", "")  # 注意数据中使用"text"字段而非"context"
            question = item.get("question", "")
            options = item.get("options", [])
            label = item.get("label", "")  # 正确答案（A、B、C、D）
            
            # 准备提示
            prompt = prepare_prompt(question, context, options)
            
            # tokenize提示
            inputs = tokenizer(prompt, return_tensors="pt").to(model.device)
            
            # 生成回复
            with torch.no_grad():
                outputs = model.generate(
                    **inputs,
                    max_new_tokens=50,  # LogiQA只需要简短答案
                    do_sample=False,    # 使用贪婪解码以获得确定性结果
                    temperature=0.7,
                    pad_token_id=tokenizer.pad_token_id
                )
            
            # 解码输出
            generated_text = tokenizer.decode(outputs[0], skip_special_tokens=False)
            
            # 提取助手回复部分
            assistant_start = generated_text.find("<|im_start|>assistant\n")
            if assistant_start != -1:
                assistant_text = generated_text[assistant_start + len("<|im_start|>assistant\n"):]
                # 移除可能的结束标记
                assistant_text = assistant_text.split("<|im_end|>")[0].strip()
            else:
                assistant_text = generated_text.replace(prompt, "").strip()
            
            # 提取预测的答案选项
            predicted_answer = extract_answer(assistant_text)
            
            # 判断是否正确
            is_correct = predicted_answer == label
            if is_correct:
                correct_count += 1
            
            # 保存结果
            result = {
                "id": item.get("id", idx),
                "context": context,
                "question": question,
                "options": options,
                "label": label,
                "predicted": predicted_answer,
                "is_correct": is_correct,
                "full_response": assistant_text
            }
            results.append(result)
            
        except Exception as e:
            logger.error(f"评估样本 {idx} 失败: {e}")
            continue
    
    # 计算准确率
    accuracy = correct_count / len(logiqa_data) if logiqa_data else 0
    logger.info(f"评估完成! 准确率: {accuracy:.4f} ({correct_count}/{len(logiqa_data)})")
    
    # 保存结果
    output_dir = os.path.dirname(args.output_path)
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    
    with open(args.output_path, 'w', encoding='utf-8') as f:
        json.dump({
            "model": args.base_model,
            "adapter": args.model_path,
            "accuracy": accuracy,
            "samples_evaluated": len(logiqa_data),
            "correct_samples": correct_count,
            "results": results
        }, f, ensure_ascii=False, indent=2)
    
    logger.info(f"评估结果已保存至: {args.output_path}")
    
    return accuracy

if __name__ == "__main__":
    args = parse_arguments()
    evaluate_model(args) 