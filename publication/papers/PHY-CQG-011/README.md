# PHY-CQG-011: Subharmonic Corrections in Gravitational Wave Ringdowns

本项目包含论文"Subharmonic Corrections in Gravitational Wave Ringdowns: A Semi-Empirical Approach with Resonant Extensions"的所有源文件和相关资料，该论文将提交至Classical and Quantum Gravity期刊。

## 项目概述

本研究提出了一种半经验性的引力波亚谐波修正模型，通过引入谐振结构修正，提高了黑洞铃振阶段的波形拟合精度。论文的主要发现包括：

1. 在多个黑洞合并事件中存在一致的亚谐波参数 ε≈0.18
2. 该亚谐波参数与多个基本物理常数有深刻联系，包括黄金分割比和精细结构常数
3. 亚谐波修正可将引力波后期拟合误差降低高达35%
4. 这些发现可能为量子引力效应在强引力场中的表现提供观测证据

## 目录结构

```
PHY-CQG-011/
├── manuscript.md              # 主要论文内容（Markdown格式）
├── outline.md                 # 论文详细大纲
├── references.md              # 参考文献列表（Markdown格式）
├── figures/                   # 图表目录
│   ├── figure1.svg            # 图1: QNM与亚谐波模型比较 
│   ├── figure2.svg            # 图2: 亚谐波参数统计分析
│   └── figure*_description.md # 图表详细说明
├── supplementary/             # 补充材料目录
│   ├── mathematical_proofs.md    # 数学证明和推导
│   ├── data_analysis_methods.md  # 数据分析方法
│   └── numerical_implementations.md # 数值实现细节
├── submission_additional_documents/ # 提交所需的额外文档
│   ├── author_info.md         # 作者信息
│   ├── conflict_of_interest.md # 利益冲突声明
│   ├── data_availability.md   # 数据可用性声明
│   └── funding_statement.md   # 资金支持声明
├── cover_letter.md            # 投稿信
├── highlights.md              # 研究亮点
├── submission_checklist.md    # 提交清单
├── status.md                  # 论文状态和进度跟踪
├── latex_template/            # LaTeX模板文件
├── submission_package/        # 提交包目录
│   ├── latex_final/           # 最终LaTeX源文件
│   ├── latex_pdf/             # 生成的PDF文件
│   └── final_submission/      # 最终提交材料
├── generate_pdfs.sh           # PDF生成脚本
├── prepare_submission.sh      # 提交包准备脚本
└── README.md                  # 本文件
```

## 当前状态

**当前状态**: READY (准备提交)

论文已完成所有内容开发和LaTeX格式化工作，包括:
- 主文档及补充材料的LaTeX格式
- 所有图表转换为PDF格式
- 参考文献BibTeX格式化
- 所有必要的提交文档准备

预计提交日期: 2025-05-30

## 使用说明

### 生成PDF文件

要生成论文的PDF文件，运行:

```bash
cd publication/papers/PHY-CQG-011
./generate_pdfs.sh
```

此脚本将编译LaTeX文件并生成以下PDF:
- `PHY-CQG-011_manuscript.pdf`: 主论文PDF
- `PHY-CQG-011_supplement.pdf`: 补充材料PDF

PDF文件将保存在 `submission_package/latex_pdf/` 目录中。

### 准备提交包

要准备最终提交包，运行:

```bash
cd publication/papers/PHY-CQG-011
./prepare_submission.sh
```

此脚本将:
1. 收集所有必要的文件
2. 生成提交清单
3. 创建最终提交压缩包 `PHY-CQG-011_submission_package.tar.gz`

### 提交到期刊

1. 下载生成的压缩包 `PHY-CQG-011_submission_package.tar.gz`
2. 登录Classical and Quantum Gravity期刊投稿系统
3. 按照系统提示上传必要文件
4. 确认所有元数据正确
5. 完成提交

## 作者

- **Haobo Ma** (auric@aelf.io) - AELF PTE LTD.
- **Wen Niu** (ada@aelf.io) - AELF PTE LTD.

## 版本信息

版本: 1.3
最后更新: 2025-05-27 