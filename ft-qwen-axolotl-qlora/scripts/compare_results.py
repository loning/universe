#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
LogiQA评估结果比较脚本
宇宙本论 v37.5
"""

import os
import json
import argparse
import logging
import matplotlib.pyplot as plt
import numpy as np
from datetime import datetime
from collections import Counter, defaultdict

# 设置日志记录
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def parse_arguments():
    parser = argparse.ArgumentParser(description="LogiQA评估结果比较工具")
    parser.add_argument("--results_dir", type=str, default="../output",
                      help="评估结果文件所在目录")
    parser.add_argument("--baseline_path", type=str, default=None,
                      help="基准模型结果文件路径(可选)")
    parser.add_argument("--output_dir", type=str, default="../output/reports",
                      help="比较报告输出目录")
    parser.add_argument("--title", type=str, default="LogiQA模型比较报告",
                      help="报告标题")
    parser.add_argument("--include_pattern", type=str, default="logiqa_results*.json",
                      help="结果文件匹配模式")
    return parser.parse_args()

def load_result_file(file_path):
    """加载单个评估结果文件"""
    try:
        logger.info(f"尝试加载结果文件: {file_path}")
        if not os.path.exists(file_path):
            logger.error(f"文件不存在: {file_path}")
            return None
        
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        # 提取关键信息
        result = {
            "model": data.get("model", "未知模型"),
            "adapter": os.path.basename(data.get("adapter", "未知适配器")),
            "accuracy": data.get("accuracy", 0),
            "samples": data.get("samples_evaluated", 0),
            "correct": data.get("correct_samples", 0),
            "file_path": file_path,
            "is_baseline": False
        }
        
        # 生成模型显示名称
        base_model = os.path.basename(result["model"])
        adapter = os.path.basename(result["adapter"])
        if "checkpoint" in adapter:
            result["display_name"] = f"{base_model}+{adapter}"
        else:
            result["display_name"] = f"{base_model}+自定义适配器"
        
        return result
    
    except Exception as e:
        logger.error(f"加载文件失败 {file_path}: {e}")
        return None

def find_result_files(results_dir, pattern):
    """查找目录中所有匹配的结果文件"""
    result_files = []
    
    try:
        import glob
        file_pattern = os.path.join(results_dir, pattern)
        result_files = glob.glob(file_pattern)
        logger.info(f"找到 {len(result_files)} 个结果文件")
    
    except Exception as e:
        logger.error(f"查找结果文件失败: {e}")
    
    return result_files

def compare_results(results_list, baseline=None):
    """比较多个评估结果"""
    if baseline:
        baseline["is_baseline"] = True
        results_list.append(baseline)
    
    # 按准确率排序
    sorted_results = sorted(results_list, key=lambda x: x["accuracy"], reverse=True)
    
    # 计算与基准的相对改进
    if baseline:
        baseline_acc = baseline["accuracy"]
        for result in sorted_results:
            if not result["is_baseline"]:
                rel_improvement = (result["accuracy"] - baseline_acc) / baseline_acc * 100
                result["rel_improvement"] = rel_improvement
    
    return sorted_results

def generate_comparison_charts(results, output_dir, title):
    """生成比较图表"""
    plt.style.use('ggplot')
    
    # 提取数据
    model_names = [r["display_name"] for r in results]
    accuracies = [r["accuracy"] for r in results]
    
    # 确定基准模型和其他模型
    baseline_idx = None
    for i, result in enumerate(results):
        if result.get("is_baseline", False):
            baseline_idx = i
            break
    
    # 准确率条形图
    plt.figure(figsize=(12, 6))
    bars = plt.bar(model_names, accuracies, color=['#2196F3' if i != baseline_idx else '#FFA726' for i in range(len(results))])
    plt.title('Model Accuracy Comparison on LogiQA')
    plt.ylim(0, max(accuracies) * 1.2)  # 给顶部留些空间
    plt.xlabel('Models')
    plt.ylabel('Accuracy')
    plt.xticks(rotation=45, ha='right')
    plt.tight_layout()
    
    # 添加数值标签
    for bar in bars:
        height = bar.get_height()
        plt.text(bar.get_x() + bar.get_width()/2., height + 0.01,
                f'{height:.4f}', ha='center', va='bottom')
    
    # 保存图表
    accuracy_chart_path = os.path.join(output_dir, 'model_comparison_accuracy.png')
    plt.savefig(accuracy_chart_path)
    plt.close()
    
    # 如果有基准模型，生成相对改进图
    if baseline_idx is not None:
        # 排除基准模型本身
        model_names_rel = [r["display_name"] for i, r in enumerate(results) if i != baseline_idx]
        rel_improvements = [r.get("rel_improvement", 0) for r in results if not r.get("is_baseline", False)]
        
        if rel_improvements:
            plt.figure(figsize=(12, 6))
            bars = plt.bar(model_names_rel, rel_improvements, color=['#4CAF50' if imp > 0 else '#F44336' for imp in rel_improvements])
            plt.title(f'Relative Improvement over Baseline ({results[baseline_idx]["display_name"]})')
            plt.xlabel('Models')
            plt.ylabel('Improvement (%)')
            plt.xticks(rotation=45, ha='right')
            plt.tight_layout()
            plt.grid(axis='y', linestyle='--', alpha=0.7)
            
            # 添加数值标签
            for bar in bars:
                height = bar.get_height()
                plt.text(bar.get_x() + bar.get_width()/2., height + 0.5,
                        f'{height:.2f}%', ha='center', va='bottom')
            
            # 保存图表
            rel_chart_path = os.path.join(output_dir, 'model_relative_improvement.png')
            plt.savefig(rel_chart_path)
            plt.close()
    
    return True

def generate_html_report(results, args):
    """生成HTML格式的比较报告"""
    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    # 构建HTML报告
    html = []
    html.append('<!DOCTYPE html>')
    html.append('<html>')
    html.append('<head>')
    html.append(f'<title>{args.title}</title>')
    html.append('<meta charset="utf-8">')
    html.append('<style>')
    html.append('body { font-family: Arial, sans-serif; margin: 20px; }')
    html.append('h1, h2 { color: #333; }')
    html.append('table { border-collapse: collapse; width: 100%; margin: 15px 0; }')
    html.append('th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }')
    html.append('th { background-color: #f2f2f2; }')
    html.append('tr:nth-child(even) { background-color: #f9f9f9; }')
    html.append('.stats-card { background: #f5f5f5; padding: 15px; border-radius: 5px; margin: 10px 0; }')
    html.append('.baseline { background-color: #fff3e0; }')
    html.append('.best { background-color: #e8f5e9; }')
    html.append('.container { display: flex; flex-wrap: wrap; }')
    html.append('.chart { flex: 1; min-width: 300px; margin: 10px; text-align: center; }')
    html.append('.positive { color: #4CAF50; }')
    html.append('.negative { color: #F44336; }')
    html.append('</style>')
    html.append('</head>')
    html.append('<body>')
    
    # 标题和基本信息
    html.append(f'<h1>{args.title}</h1>')
    html.append(f'<p>生成时间: {now}</p>')
    
    # 图表部分
    html.append('<div class="container">')
    html.append('<div class="chart">')
    html.append('<h2>模型准确率比较</h2>')
    html.append(f'<img src="model_comparison_accuracy.png" alt="模型准确率比较" width="100%">')
    html.append('</div>')
    
    # 如果有基准模型，添加相对改进图表
    baseline = None
    for result in results:
        if result.get("is_baseline", False):
            baseline = result
            break
    
    if baseline:
        html.append('<div class="chart">')
        html.append(f'<h2>相对于基准的改进 ({baseline["display_name"]})</h2>')
        html.append(f'<img src="model_relative_improvement.png" alt="相对改进比较" width="100%">')
        html.append('</div>')
    
    html.append('</div>')
    
    # 结果表格
    html.append('<div class="stats-card">')
    html.append('<h2>模型性能对比</h2>')
    html.append('<table>')
    html.append('<tr><th>模型</th><th>准确率</th><th>样本数</th><th>正确数</th>')
    if baseline:
        html.append('<th>相对改进</th>')
    html.append('<th>文件路径</th></tr>')
    
    for result in results:
        # 确定CSS类
        row_class = ""
        if result.get("is_baseline", False):
            row_class = "baseline"
        elif result == results[0]:  # 最好的结果
            row_class = "best"
        
        html.append(f'<tr class="{row_class}">')
        html.append(f'<td>{result["display_name"]}</td>')
        html.append(f'<td>{result["accuracy"]:.4f}</td>')
        html.append(f'<td>{result["samples"]}</td>')
        html.append(f'<td>{result["correct"]}</td>')
        
        if baseline:
            if not result.get("is_baseline", False):
                rel_imp = result.get("rel_improvement", 0)
                imp_class = "positive" if rel_imp > 0 else "negative"
                html.append(f'<td class="{imp_class}">{rel_imp:.2f}%</td>')
            else:
                html.append('<td>基准</td>')
        
        html.append(f'<td>{os.path.basename(result["file_path"])}</td>')
        html.append('</tr>')
    
    html.append('</table>')
    html.append('</div>')
    
    # 分析与结论
    html.append('<div class="stats-card">')
    html.append('<h2>分析与结论</h2>')
    
    # 找出最好的模型
    best_model = results[0]
    html.append(f'<p>在所有测试的模型中，<strong>{best_model["display_name"]}</strong> 表现最好，准确率为 {best_model["accuracy"]:.4f}。</p>')
    
    if baseline:
        best_non_baseline = next((r for r in results if not r.get("is_baseline", False)), None)
        if best_non_baseline:
            rel_imp = best_non_baseline.get("rel_improvement", 0)
            if rel_imp > 0:
                html.append(f'<p>与基准模型 {baseline["display_name"]} 相比，最佳模型提升了 <span class="positive">{rel_imp:.2f}%</span>。</p>')
            else:
                html.append(f'<p>与基准模型 {baseline["display_name"]} 相比，最佳模型性能降低了 <span class="negative">{abs(rel_imp):.2f}%</span>。</p>')
    
    html.append('<p>建议：</p>')
    html.append('<ul>')
    html.append('<li>继续使用最佳模型进行实际应用</li>')
    html.append('<li>对性能最好的模型进行更深入的错误分析</li>')
    html.append('<li>考虑尝试不同的训练参数以进一步提高性能</li>')
    html.append('</ul>')
    
    html.append('</div>')
    
    html.append('<div class="stats-card">')
    html.append('<h2>比较说明</h2>')
    html.append('<p>本报告比较了不同模型在LogiQA逻辑推理基准测试上的表现。LogiQA是一个专注于测试模型逻辑推理能力的基准，包括演绎、归纳和类比等多种推理形式。</p>')
    html.append('<p>评估指标：</p>')
    html.append('<ul>')
    html.append('<li><strong>准确率</strong>：模型在测试集上的正确答案比例</li>')
    if baseline:
        html.append('<li><strong>相对改进</strong>：与基准模型相比的准确率百分比提升</li>')
    html.append('</ul>')
    html.append('</div>')
    
    html.append('</body>')
    html.append('</html>')
    
    return "\n".join(html)

def main():
    # 解析命令行参数
    args = parse_arguments()
    
    # 查找结果文件
    result_files = find_result_files(args.results_dir, args.include_pattern)
    if not result_files:
        logger.error(f"在目录 {args.results_dir} 中未找到评估结果文件")
        return
    
    # 加载结果文件
    results_list = []
    for file_path in result_files:
        result = load_result_file(file_path)
        if result:
            results_list.append(result)
    
    if not results_list:
        logger.error("未能成功加载任何结果文件")
        return
    
    # 加载基准结果（如果提供）
    baseline = None
    if args.baseline_path:
        baseline = load_result_file(args.baseline_path)
        if not baseline:
            logger.warning(f"无法加载基准文件: {args.baseline_path}")
    
    # 比较结果
    comparison_results = compare_results(results_list, baseline)
    
    # 创建输出目录
    os.makedirs(args.output_dir, exist_ok=True)
    
    # 生成比较图表
    generate_comparison_charts(comparison_results, args.output_dir, args.title)
    
    # 生成报告
    html_report = generate_html_report(comparison_results, args)
    
    # 生成报告名称（基于当前时间）
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    html_path = os.path.join(args.output_dir, f"model_comparison_report_{timestamp}.html")
    
    # 保存HTML报告
    with open(html_path, 'w', encoding='utf-8') as f:
        f.write(html_report)
    
    logger.info(f"比较报告已保存至: {html_path}")

if __name__ == "__main__":
    main() 