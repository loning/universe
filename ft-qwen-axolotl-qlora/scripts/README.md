# Qwen 模型微调与评估工具

宇宙本论 v37.5

本目录包含用于微调Qwen模型（使用宇宙本论数据集）和在LogiQA基准上评估模型性能的脚本。

## 项目结构

```
ft-qwen-axolotl-qlora/
├── config.yaml              # 模型训练配置文件
├── data/                    # 数据目录
│   ├── cosmos_ontology.jsonl  # 宇宙本论训练数据
│   └── logiqa_test.jsonl    # LogiQA测试数据
├── output/                  # 输出目录
│   └── qwen-qlora-ft/       # 微调模型输出
│       └── checkpoint-3/    # 模型检查点
└── scripts/                 # 脚本目录
    ├── main.bat             # 主入口脚本
    ├── train_cosmos.bat     # 宇宙本论训练脚本
    ├── download_data.py     # 数据下载脚本
    ├── evaluate_logiqa.py   # LogiQA评估实现
    ├── evaluate_logiqa.bat  # LogiQA评估批处理脚本
    └── README.md            # 本文档
```

## 快速开始

### 使用主入口脚本（推荐）

最简单的方式是使用统一的主入口脚本，它提供了所有功能的菜单界面：

```bash
cd scripts
main.bat
```

这将显示以下选项菜单：
1. 使用宇宙本论数据训练模型
2. 在LogiQA上评估模型
3. 下载所需数据
4. 退出

### 单独使用各功能脚本

如果您想直接使用某个特定功能，也可以单独运行相应脚本：

#### 训练模型

使用宇宙本论(cosmos_ontology)数据集训练Qwen模型：

```bash
cd scripts
train_cosmos.bat
```

#### 评估模型

在LogiQA逻辑推理基准测试上评估微调模型：

```bash
cd scripts
evaluate_logiqa.bat
```

选择操作:
1. 下载LogiQA数据集（如果需要）
2. 运行完整评估
3. 运行快速评估（50个样本）

## 脚本说明

### `main.bat`

主入口脚本，整合了所有功能，提供统一的交互式菜单界面：
- 训练模型功能
- 评估模型功能
- 数据下载管理
- 用户友好的菜单导航

### `train_cosmos.bat`

使用宇宙本论数据集训练Qwen模型的批处理脚本。脚本会：
- 自动设置正确的环境变量
- 激活conda base环境
- 安装必要的依赖
- 启动训练过程

### `download_data.py`

下载所需数据集的Python脚本：

```bash
python download_data.py --dataset=logiqa --output_dir="../data"
```

参数:
- `--dataset`: 要下载的数据集 (logiqa 或 cosmos)
- `--output_dir`: 数据保存目录

### `evaluate_logiqa.py`

评估微调模型在LogiQA测试集上性能的Python脚本：

```bash
python evaluate_logiqa.py --model_path="../output/qwen-qlora-ft/checkpoint-3" --base_model="Qwen/Qwen-1_8B-Chat" --data_path="../data/logiqa_test.jsonl" --output_path="../output/logiqa_results.json" --device=cuda
```

参数:
- `--model_path`: 微调模型路径
- `--base_model`: 基础模型名称
- `--data_path`: LogiQA测试集路径
- `--output_path`: 评估结果输出路径
- `--max_samples`: 评估样本数量（默认为全部）
- `--device`: 使用的设备 (cuda 或 cpu)

### `evaluate_logiqa.bat`

用户友好的LogiQA评估批处理脚本，提供菜单界面选择操作。

## 配置文件说明

`config.yaml` 文件包含模型训练配置，主要参数：

```yaml
base_model: Qwen/Qwen-1_8B-Chat  # 基础模型名称
datasets:
  - path: ./data/cosmos_ontology.jsonl  # 训练数据路径
    type: alpaca
lora:
  r: 64                          # LoRA 秩
  alpha: 16                      # LoRA alpha参数
  dropout: 0.05                  # LoRA dropout
  target_modules: ["c_attn", "c_proj"]  # 目标模块
```

## 评估结果

模型评估结果存储在 `output/logiqa_results.json` 或 `output/logiqa_results_quick.json` 中，包含：

- 准确率
- 正确样本数
- 总样本数
- 模型名称
- Adapter名称

## 工作流程

1. 运行 `main.bat` 选择需要的功能
2. 或直接使用 `train_cosmos.bat` 在宇宙本论数据集上训练模型
3. 使用 `evaluate_logiqa.bat` 评估训练后的模型在LogiQA上的表现
4. 分析评估结果 