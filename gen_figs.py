#!/usr/bin/env python3
# 简单图表生成器 - 为LaTeX文档创建示例图表

import os
import numpy as np
import matplotlib.pyplot as plt

# 创建输出目录
figure_dir = 'submission_package/latex_final/figures'
os.makedirs(figure_dir, exist_ok=True)

# 简单示例图1 - 四面板
def create_example_figure1():
    fig, axs = plt.subplots(2, 2, figsize=(8, 6))
    
    # 简单线图
    x = np.linspace(0, 10, 100)
    axs[0, 0].plot(x, np.sin(x), 'b-', label='Signal')
    axs[0, 0].plot(x, np.sin(x)*0.5, 'r--', label='Model')
    axs[0, 0].set_title('(a) Waveform')
    axs[0, 0].legend()
    
    # 简单条形图
    axs[0, 1].bar(['A', 'B', 'C', 'D'], [3, 1, 4, 2])
    axs[0, 1].set_title('(b) Comparison')
    
    # 简单等高线图
    x, y = np.meshgrid(np.linspace(-2, 2, 30), np.linspace(-2, 2, 30))
    z = np.exp(-(x**2 + y**2)/2)
    axs[1, 0].contourf(x, y, z, 20)
    axs[1, 0].set_title('(c) Distribution')
    
    # 简单散点图
    data = np.random.randn(20, 2)
    axs[1, 1].scatter(data[:, 0], data[:, 1])
    axs[1, 1].set_title('(d) Results')
    
    plt.tight_layout()
    plt.savefig(f'{figure_dir}/figure1.pdf')
    print(f"已生成图表1: {figure_dir}/figure1.pdf")
    
# 简单示例图2 - 四面板
def create_example_figure2():
    fig, axs = plt.subplots(2, 2, figsize=(8, 6))
    
    # 简单曲线
    x = np.linspace(0, 5, 100)
    axs[0, 0].plot(x, x**2, 'r-', label='A')
    axs[0, 0].plot(x, x**2 - x, 'b--', label='B')
    axs[0, 0].set_title('(a) Comparison')
    axs[0, 0].legend()
    
    # 简单直方图
    data = np.random.normal(0, 1, 1000)
    axs[0, 1].hist(data, bins=20)
    axs[0, 1].set_title('(b) Distribution')
    
    # 简单热图
    data = np.random.rand(10, 10)
    axs[1, 0].imshow(data)
    axs[1, 0].set_title('(c) Heat Map')
    
    # 简单饼图
    axs[1, 1].pie([15, 30, 45, 10], labels=['A', 'B', 'C', 'D'])
    axs[1, 1].set_title('(d) Proportions')
    
    plt.tight_layout()
    plt.savefig(f'{figure_dir}/figure2.pdf')
    print(f"已生成图表2: {figure_dir}/figure2.pdf")

if __name__ == "__main__":
    print("开始生成示例图表...")
    create_example_figure1()
    create_example_figure2()
    print("图表生成完成!") 