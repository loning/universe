#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
评估结果报告生成脚本
宇宙本论 v37.5
"""

import os
import json
import argparse
import logging
import matplotlib.pyplot as plt
from datetime import datetime
from collections import Counter

# 设置日志记录
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def parse_arguments():
    parser = argparse.ArgumentParser(description="LogiQA评估结果报告生成器")
    parser.add_argument("--input_path", type=str, required=True,
                      help="评估结果JSON文件路径")
    parser.add_argument("--output_dir", type=str, default="../output/reports",
                      help="报告输出目录")
    parser.add_argument("--format", type=str, choices=["html", "text", "both"], default="both",
                      help="报告格式：html, text, both")
    parser.add_argument("--title", type=str, default="LogiQA评估报告",
                      help="报告标题")
    return parser.parse_args()

def load_results(file_path):
    """加载评估结果JSON文件"""
    try:
        # 检查文件路径是否绝对路径
        file_path = os.path.abspath(file_path)
        logger.info(f"尝试加载评估结果，完整路径: {file_path}")
        
        # 检查文件是否存在
        if not os.path.exists(file_path):
            logger.error(f"文件不存在: {file_path}")
            # 尝试在多个可能的路径下查找
            potential_paths = [
                file_path,
                os.path.join(os.getcwd(), os.path.basename(file_path)),
                os.path.join(os.path.dirname(os.path.dirname(os.getcwd())), "output", os.path.basename(file_path))
            ]
            for path in potential_paths:
                if os.path.exists(path):
                    logger.info(f"找到替代文件路径: {path}")
                    file_path = path
                    break
            
            if not os.path.exists(file_path):
                logger.error(f"在所有可能的位置均未找到文件")
                return None
        
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        logger.info(f"成功加载评估结果: {file_path}")
        return data
    except Exception as e:
        logger.error(f"加载评估结果失败: {e}")
        return None

def generate_confusion_matrix(results):
    """生成混淆矩阵数据"""
    # 初始化混淆矩阵
    labels = ["A", "B", "C", "D"]
    confusion_matrix = {true: {pred: 0 for pred in labels} for true in labels}
    
    # 填充混淆矩阵
    for item in results:
        true_label = item["label"]
        pred_label = item["predicted"]
        if true_label in labels and pred_label in labels:
            confusion_matrix[true_label][pred_label] += 1
    
    return confusion_matrix

def analyze_results(data):
    """分析评估结果"""
    if not data or "results" not in data:
        return None
    
    results = data["results"]
    accuracy = data.get("accuracy", 0)
    
    # 按选项分析正确率
    options_stats = {}
    for label in ["A", "B", "C", "D"]:
        label_results = [r for r in results if r["label"] == label]
        if not label_results:
            continue
        correct = sum(1 for r in label_results if r["is_correct"])
        options_stats[label] = {
            "count": len(label_results),
            "correct": correct,
            "accuracy": correct / len(label_results) if label_results else 0
        }
    
    # 错误分析
    error_cases = [r for r in results if not r["is_correct"]]
    common_mistakes = Counter()
    for case in error_cases:
        mistake_pair = f"{case['label']}->{case['predicted']}"
        common_mistakes[mistake_pair] += 1
    
    # 生成混淆矩阵
    confusion_matrix = generate_confusion_matrix(results)
    
    return {
        "total_samples": len(results),
        "accuracy": accuracy,
        "options_stats": options_stats,
        "error_count": len(error_cases),
        "common_mistakes": common_mistakes.most_common(5),
        "confusion_matrix": confusion_matrix
    }

def generate_text_report(data, analysis, args):
    """生成文本格式的报告"""
    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    report = []
    report.append("=" * 60)
    report.append(f"{args.title}")
    report.append(f"生成时间: {now}")
    report.append("=" * 60)
    report.append("")
    
    # 模型信息
    report.append("模型信息:")
    report.append(f"  基础模型: {data.get('model', '未知')}")
    report.append(f"  适配器: {data.get('adapter', '未知')}")
    report.append("")
    
    # 总体性能
    report.append("总体性能:")
    report.append(f"  评估样本数: {analysis['total_samples']}")
    report.append(f"  正确样本数: {data.get('correct_samples', 0)}")
    report.append(f"  总体准确率: {analysis['accuracy']:.4f} ({data.get('correct_samples', 0)}/{analysis['total_samples']})")
    report.append("")
    
    # 按选项分析
    report.append("按选项分析:")
    for option, stats in sorted(analysis["options_stats"].items()):
        report.append(f"  选项 {option}: {stats['accuracy']:.4f} ({stats['correct']}/{stats['count']})")
    report.append("")
    
    # 常见错误
    report.append("常见错误模式:")
    for mistake, count in analysis["common_mistakes"]:
        report.append(f"  {mistake}: {count}次")
    report.append("")
    
    # 混淆矩阵
    report.append("混淆矩阵:")
    matrix = analysis["confusion_matrix"]
    report.append("  预测 ->  A     B     C     D")
    report.append("  " + "-" * 30)
    for true in ["A", "B", "C", "D"]:
        line = f"  {true} | "
        for pred in ["A", "B", "C", "D"]:
            line += f"{matrix[true][pred]:4d}  "
        report.append(line)
    report.append("")
    
    # 样本分析
    report.append("样本分析:")
    report.append(f"  正确样本: {data.get('correct_samples', 0)}")
    report.append(f"  错误样本: {analysis['error_count']}")
    
    return "\n".join(report)

def generate_html_report(data, analysis, args):
    """生成HTML格式的报告"""
    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    # 创建饼图
    plt.figure(figsize=(10, 6))
    plt.pie([data.get('correct_samples', 0), analysis['error_count']], 
            labels=['Correct', 'Incorrect'], 
            autopct='%1.1f%%',
            colors=['#4CAF50', '#F44336'])
    plt.title('Accuracy Distribution')
    pie_chart_path = os.path.join(args.output_dir, 'accuracy_pie.png')
    plt.savefig(pie_chart_path)
    plt.close()
    
    # 创建按选项的准确率条形图
    if analysis["options_stats"]:
        options = []
        accuracies = []
        for option, stats in sorted(analysis["options_stats"].items()):
            options.append(option)
            accuracies.append(stats['accuracy'])
        
        plt.figure(figsize=(10, 6))
        bars = plt.bar(options, accuracies, color='#2196F3')
        plt.title('Accuracy by Option')
        plt.ylim(0, 1.0)
        plt.xlabel('Option')
        plt.ylabel('Accuracy')
        
        # 添加数值标签
        for bar in bars:
            height = bar.get_height()
            plt.text(bar.get_x() + bar.get_width()/2.,
                    height + 0.01,
                    f'{height:.2f}',
                    ha='center', va='bottom')
        
        options_chart_path = os.path.join(args.output_dir, 'options_accuracy.png')
        plt.savefig(options_chart_path)
        plt.close()
    
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
    html.append('.correct { color: #4CAF50; }')
    html.append('.incorrect { color: #F44336; }')
    html.append('.container { display: flex; flex-wrap: wrap; }')
    html.append('.chart { flex: 1; min-width: 300px; margin: 10px; text-align: center; }')
    html.append('</style>')
    html.append('</head>')
    html.append('<body>')
    
    # 标题和基本信息
    html.append(f'<h1>{args.title}</h1>')
    html.append(f'<p>生成时间: {now}</p>')
    html.append('<div class="stats-card">')
    html.append('<h2>模型信息</h2>')
    html.append('<p><strong>基础模型:</strong> ' + data.get('model', '未知') + '</p>')
    html.append('<p><strong>适配器:</strong> ' + data.get('adapter', '未知') + '</p>')
    html.append('</div>')
    
    # 总体性能
    html.append('<div class="stats-card">')
    html.append('<h2>总体性能</h2>')
    html.append(f'<p><strong>评估样本数:</strong> {analysis["total_samples"]}</p>')
    html.append(f'<p><strong>正确样本数:</strong> {data.get("correct_samples", 0)}</p>')
    html.append(f'<p><strong>总体准确率:</strong> {analysis["accuracy"]:.4f} ({data.get("correct_samples", 0)}/{analysis["total_samples"]})</p>')
    html.append('</div>')
    
    # 图表部分
    html.append('<div class="container">')
    html.append('<div class="chart">')
    html.append('<h2>准确率分布</h2>')
    html.append(f'<img src="accuracy_pie.png" alt="准确率分布" width="100%">')
    html.append('</div>')
    
    if analysis["options_stats"]:
        html.append('<div class="chart">')
        html.append('<h2>各选项准确率</h2>')
        html.append(f'<img src="options_accuracy.png" alt="各选项准确率" width="100%">')
        html.append('</div>')
    
    html.append('</div>')
    
    # 按选项分析
    html.append('<div class="stats-card">')
    html.append('<h2>按选项分析</h2>')
    html.append('<table>')
    html.append('<tr><th>选项</th><th>样本数</th><th>正确数</th><th>准确率</th></tr>')
    for option, stats in sorted(analysis["options_stats"].items()):
        html.append(f'<tr><td>{option}</td><td>{stats["count"]}</td><td>{stats["correct"]}</td><td>{stats["accuracy"]:.4f}</td></tr>')
    html.append('</table>')
    html.append('</div>')
    
    # 常见错误
    html.append('<div class="stats-card">')
    html.append('<h2>常见错误模式</h2>')
    if analysis["common_mistakes"]:
        html.append('<table>')
        html.append('<tr><th>错误模式</th><th>次数</th></tr>')
        for mistake, count in analysis["common_mistakes"]:
            html.append(f'<tr><td>{mistake}</td><td>{count}</td></tr>')
        html.append('</table>')
    else:
        html.append('<p>无错误数据</p>')
    html.append('</div>')
    
    # 混淆矩阵
    html.append('<div class="stats-card">')
    html.append('<h2>混淆矩阵</h2>')
    html.append('<table>')
    matrix = analysis["confusion_matrix"]
    html.append('<tr><th>真实\\预测</th><th>A</th><th>B</th><th>C</th><th>D</th></tr>')
    for true in ["A", "B", "C", "D"]:
        html.append(f'<tr><th>{true}</th>')
        for pred in ["A", "B", "C", "D"]:
            cell_class = "correct" if true == pred else ""
            html.append(f'<td class="{cell_class}">{matrix[true][pred]}</td>')
        html.append('</tr>')
    html.append('</table>')
    html.append('</div>')
    
    # 样本详情
    html.append('<div class="stats-card">')
    html.append('<h2>样本详情</h2>')
    html.append('<table>')
    html.append('<tr><th>ID</th><th>问题</th><th>正确答案</th><th>预测答案</th><th>结果</th></tr>')
    for item in data.get("results", [])[:10]:  # 只显示前10个样本
        result_class = "correct" if item["is_correct"] else "incorrect"
        result_text = "正确" if item["is_correct"] else "错误"
        html.append(f'<tr>')
        html.append(f'<td>{item.get("id", "")}</td>')
        html.append(f'<td>{item.get("question", "")[:50]}...</td>')
        html.append(f'<td>{item.get("label", "")}</td>')
        html.append(f'<td>{item.get("predicted", "")}</td>')
        html.append(f'<td class="{result_class}">{result_text}</td>')
        html.append(f'</tr>')
    html.append('</table>')
    html.append(f'<p>显示前10个样本，共{len(data.get("results", []))}个样本。</p>')
    html.append('</div>')
    
    html.append('</body>')
    html.append('</html>')
    
    return "\n".join(html)

def main():
    # 解析命令行参数
    args = parse_arguments()
    
    # 加载评估结果
    data = load_results(args.input_path)
    if not data:
        logger.error("无法生成报告：评估结果加载失败")
        return
    
    # 分析结果
    analysis = analyze_results(data)
    if not analysis:
        logger.error("无法生成报告：结果分析失败")
        return
    
    # 创建输出目录
    os.makedirs(args.output_dir, exist_ok=True)
    
    # 生成报告名称（基于当前时间）
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    base_filename = f"logiqa_report_{timestamp}"
    
    # 生成报告
    if args.format in ["text", "both"]:
        text_report = generate_text_report(data, analysis, args)
        text_path = os.path.join(args.output_dir, f"{base_filename}.txt")
        with open(text_path, 'w', encoding='utf-8') as f:
            f.write(text_report)
        logger.info(f"文本报告已生成: {text_path}")
    
    if args.format in ["html", "both"]:
        html_report = generate_html_report(data, analysis, args)
        html_path = os.path.join(args.output_dir, f"{base_filename}.html")
        with open(html_path, 'w', encoding='utf-8') as f:
            f.write(html_report)
        logger.info(f"HTML报告已生成: {html_path}")
    
    logger.info("报告生成完成!")

if __name__ == "__main__":
    main() 