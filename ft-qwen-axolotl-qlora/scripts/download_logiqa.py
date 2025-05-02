"""
下载LogiQA数据集的辅助脚本
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
    parser = argparse.ArgumentParser(description="下载LogiQA数据集")
    parser.add_argument("--output_dir", type=str, default="../data",
                      help="下载数据集的输出目录")
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
        
        # 下载文件并显示进度
        with open(output_path, 'wb') as f, tqdm(
            desc=os.path.basename(output_path),
            total=total_size,
            unit='B',
            unit_scale=True,
            unit_divisor=1024,
        ) as progress_bar:
            for chunk in response.iter_content(chunk_size=1024):
                if chunk:  # 过滤保持活跃的新块
                    f.write(chunk)
                    progress_bar.update(len(chunk))
        
        return True
    except requests.exceptions.RequestException as e:
        logger.error(f"下载失败: {e}")
        return False

def main():
    args = parse_arguments()
    
    # LogiQA 数据集URLs - 更新为LogiQA2.0仓库的正确路径
    # 使用LogiQA2.0仓库中的数据集文件
    logiqa_train_url = "https://raw.githubusercontent.com/csitfun/LogiQA2.0/main/logiqa/DATA/LOGIQA/train.txt"
    logiqa_dev_url = "https://raw.githubusercontent.com/csitfun/LogiQA2.0/main/logiqa/DATA/LOGIQA/dev.txt" 
    logiqa_test_url = "https://raw.githubusercontent.com/csitfun/LogiQA2.0/main/logiqa/DATA/LOGIQA/test.txt"
    
    # 创建输出目录
    os.makedirs(args.output_dir, exist_ok=True)
    
    # 下载LogiQA训练集
    train_output_path = os.path.join(args.output_dir, "logiqa_train.jsonl")
    logger.info(f"开始下载LogiQA训练集到 {train_output_path}")
    if download_file(logiqa_train_url, train_output_path):
        logger.info(f"LogiQA训练集下载成功! 保存在: {train_output_path}")
    else:
        logger.error("LogiQA训练集下载失败")
        return 1
    
    # 下载LogiQA开发集
    dev_output_path = os.path.join(args.output_dir, "logiqa_dev.jsonl")
    logger.info(f"开始下载LogiQA开发集到 {dev_output_path}")
    if download_file(logiqa_dev_url, dev_output_path):
        logger.info(f"LogiQA开发集下载成功! 保存在: {dev_output_path}")
    else:
        logger.error("LogiQA开发集下载失败")
        return 1
    
    # 下载LogiQA测试集
    test_output_path = os.path.join(args.output_dir, "logiqa_test.jsonl")
    logger.info(f"开始下载LogiQA测试集到 {test_output_path}")
    if download_file(logiqa_test_url, test_output_path):
        logger.info(f"LogiQA测试集下载成功! 保存在: {test_output_path}")
    else:
        logger.error("LogiQA测试集下载失败")
        return 1
    
    logger.info("所有LogiQA数据集文件下载完成!")
    return 0

if __name__ == "__main__":
    sys.exit(main()) 