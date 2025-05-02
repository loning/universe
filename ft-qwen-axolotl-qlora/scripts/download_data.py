"""
下载评估和训练所需数据集的辅助脚本
宇宙本论 v37.5
"""

import os
import sys
import argparse
import requests
from tqdm import tqdm
import logging

# 设置日志记录
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

def parse_arguments():
    parser = argparse.ArgumentParser(description="下载数据集")
    parser.add_argument("--output_dir", type=str, default="../data",
                      help="下载数据集的输出目录")
    parser.add_argument("--dataset", type=str, default="logiqa", choices=["logiqa", "cosmos"],
                      help="要下载的数据集，可选：logiqa, cosmos")
    return parser.parse_args()

def download_file(url, output_path):
    """
    下载文件并显示进度条
    """
    try:
        response = requests.get(url, stream=True)
        response.raise_for_status()
        
        # 获取文件大小
        total_size = int(response.headers.get('content-length', 0))
        
        # 确保目录存在
        os.makedirs(os.path.dirname(output_path), exist_ok=True)
        
        # 下载文件并显示进度条
        with open(output_path, 'wb') as f, tqdm(
            desc=os.path.basename(output_path),
            total=total_size,
            unit='B',
            unit_scale=True,
            unit_divisor=1024,
        ) as bar:
            for data in response.iter_content(chunk_size=1024):
                size = f.write(data)
                bar.update(size)
        
        logger.info(f"文件下载成功: {output_path}")
        return True
    except Exception as e:
        logger.error(f"下载文件失败: {e}")
        return False

def download_logiqa_dataset(output_dir):
    """
    下载LogiQA数据集
    """
    # 数据集URL
    logiqa_train_url = "https://github.com/csitfun/LogiQA2.0/raw/main/LogiQA.jsonl"
    logiqa_test_url = "https://github.com/csitfun/LogiQA2.0/raw/main/LogiQA.jsonl"
    
    # 输出路径
    logiqa_train_path = os.path.join(output_dir, "logiqa_train.jsonl")
    logiqa_test_path = os.path.join(output_dir, "logiqa_test.jsonl")
    
    # 下载训练集
    logger.info("正在下载LogiQA训练集...")
    if download_file(logiqa_train_url, logiqa_train_path):
        logger.info(f"LogiQA训练集已保存到: {logiqa_train_path}")
    else:
        logger.error("LogiQA训练集下载失败")
    
    # 下载测试集（实际上目前使用相同的文件）
    logger.info("正在下载LogiQA测试集...")
    if download_file(logiqa_test_url, logiqa_test_path):
        logger.info(f"LogiQA测试集已保存到: {logiqa_test_path}")
    else:
        logger.error("LogiQA测试集下载失败")

def main():
    args = parse_arguments()
    
    # 确保输出目录存在
    os.makedirs(args.output_dir, exist_ok=True)
    
    if args.dataset == "logiqa":
        download_logiqa_dataset(args.output_dir)
    elif args.dataset == "cosmos":
        logger.info("宇宙本论数据集需要从项目仓库手动获取")
    else:
        logger.error(f"未知的数据集: {args.dataset}")
        sys.exit(1)
    
    logger.info("数据集下载完成")

if __name__ == "__main__":
    main() 