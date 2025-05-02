"""
QWen微调模型评估脚本
宇宙本论 v37.5
"""

import os
import torch
import argparse
import logging
from transformers import AutoModelForCausalLM, AutoTokenizer, BitsAndBytesConfig
from peft import PeftModel

# 设置日志记录
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def parse_arguments():
    parser = argparse.ArgumentParser(description="QWen微调模型评估脚本")
    parser.add_argument("--model_path", type=str, default="../output/qwen-qlora-ft/checkpoint-3",
                      help="微调模型路径")
    parser.add_argument("--base_model", type=str, default="Qwen/Qwen-1_8B-Chat",
                      help="基础模型名称")
    parser.add_argument("--prompt", type=str, 
                      default="介绍一下宇宙本论的基本概念",
                      help="提示文本")
    parser.add_argument("--max_length", type=int, default=512,
                      help="生成文本的最大长度")
    parser.add_argument("--device", type=str, default="auto",
                      help="设备: auto, cpu, cuda, cuda:0, etc.")
    parser.add_argument("--use_4bit", action="store_true",
                      help="使用4bit量化加载模型")
    return parser.parse_args()

def prepare_prompt(prompt, tokenizer):
    """准备提示格式"""
    formatted_prompt = f"<|im_start|>user\n{prompt}<|im_end|>\n<|im_start|>assistant\n"
    return formatted_prompt

def evaluate_model(args):
    """加载和评估微调模型"""
    logger.info(f"加载基础模型: {args.base_model}")
    
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
    
    # 准备提示
    prompt = prepare_prompt(args.prompt, tokenizer)
    logger.info(f"提示: {prompt}")
    
    # tokenize提示
    inputs = tokenizer(prompt, return_tensors="pt").to(model.device)
    
    # 生成回复
    logger.info("生成回复...")
    with torch.no_grad():
        outputs = model.generate(
            **inputs,
            max_new_tokens=args.max_length,
            do_sample=True,
            temperature=0.7,
            top_p=0.9,
            repetition_penalty=1.1,
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
    
    return assistant_text

def interactive_mode(args):
    """交互式模式，允许用户输入多个提示"""
    logger.info(f"加载基础模型: {args.base_model}")
    
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
    
    print("\n" + "="*50)
    print(f"微调模型已加载。输入 'q' 或 'quit' 退出。")
    print("="*50 + "\n")
    
    # 聊天历史
    chat_history = []
    
    while True:
        user_input = input("\n用户: ")
        if user_input.lower() in ['q', 'quit', 'exit']:
            break
        
        # 构建完整对话历史
        full_prompt = ""
        for turn in chat_history:
            full_prompt += f"<|im_start|>user\n{turn['user']}<|im_end|>\n"
            full_prompt += f"<|im_start|>assistant\n{turn['assistant']}<|im_end|>\n"
        
        # 添加当前用户输入
        full_prompt += f"<|im_start|>user\n{user_input}<|im_end|>\n<|im_start|>assistant\n"
        
        # tokenize提示
        inputs = tokenizer(full_prompt, return_tensors="pt").to(model.device)
        
        # 生成回复
        with torch.no_grad():
            outputs = model.generate(
                **inputs,
                max_new_tokens=args.max_length,
                do_sample=True,
                temperature=0.7,
                top_p=0.9,
                repetition_penalty=1.1,
                pad_token_id=tokenizer.pad_token_id
            )
        
        # 解码输出
        generated_text = tokenizer.decode(outputs[0], skip_special_tokens=False)
        
        # 提取助手回复部分
        assistant_start = generated_text.rfind("<|im_start|>assistant\n")
        if assistant_start != -1:
            assistant_text = generated_text[assistant_start + len("<|im_start|>assistant\n"):]
            # 移除可能的结束标记
            assistant_text = assistant_text.split("<|im_end|>")[0].strip()
        else:
            assistant_text = "无法提取回复。"
        
        # 打印助手回复
        print(f"\n助手: {assistant_text}\n")
        
        # 更新聊天历史
        chat_history.append({
            "user": user_input,
            "assistant": assistant_text
        })

if __name__ == "__main__":
    args = parse_arguments()
    
    if args.prompt == "interactive":
        interactive_mode(args)
    else:
        assistant_reply = evaluate_model(args)
        print("\n" + "="*50)
        print("模型回复:")
        print("="*50)
        print(assistant_reply)
        print("="*50 + "\n") 