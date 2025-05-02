# Qwen微调模型LogiQA评估指南

本指南介绍如何使用LogiQA基准测试评估我们微调的Qwen模型，以及如何针对逻辑推理能力训练模型。LogiQA是一个专注于逻辑推理能力的问答基准测试。

## 目录
1. [什么是LogiQA](#什么是logiqa)
2. [训练步骤](#训练步骤)
3. [评估流程](#评估流程)
4. [评估结果说明](#评估结果说明)
5. [性能对比参考](#性能对比参考)
6. [可能的问题与解决方案](#可能的问题与解决方案)
7. [进一步改进建议](#进一步改进建议)

## 什么是LogiQA

LogiQA（Logical Question Answering）是一个专门设计用于测试语言模型逻辑推理能力的基准测试集。它包含了一系列多选题，每题都需要模型根据给定的背景信息进行逻辑分析和推理，从而选择正确答案。

LogiQA的问题类型主要包括：
- 逻辑推导
- 条件推理
- 归纳与演绎
- 矛盾识别
- 等价关系判断

## 训练步骤

要针对LogiQA逻辑推理任务微调Qwen模型，可按照以下步骤进行：

### 1. 准备数据集

首先，需要下载并准备LogiQA数据集：

```bash
# 切换到scripts目录
cd scripts

# 下载LogiQA数据集
python download_logiqa.py --output_dir="../data"

# 转换为训练格式
python prepare_logiqa_training.py --input_path="../data/logiqa.jsonl" --output_path="../data/logiqa.jsonl" --split_ratio=0.9
```

这个步骤会将原始数据集分割为训练集和验证集，保存为`data/logiqa_train.jsonl`和`data/logiqa_val.jsonl`，并生成配置文件。

### 2. 配置训练参数

数据准备完成后，需要确认项目根目录下的`config.yaml`文件内容，配置模型训练参数：

```yaml
base_model: "Qwen/Qwen-1_8B-Chat"  # 基础模型
trust_remote_code: true
device: cpu
output_dir: ./output/qwen-qlora-ft-logiqa

datasets:
  - path: ./data/logiqa_train.jsonl
    type: alpaca

# QLoRA参数
lora:
  r: 64
  alpha: 16
  dropout: 0.05
  target_modules: ["c_attn", "c_proj"]
  bias: none
  task_type: CAUSAL_LM

micro_batch_size: 4
gradient_accumulation_steps: 8
learning_rate: 2e-4

# 训练参数
train:
  num_train_epochs: 3
  max_grad_norm: 1.0
  weight_decay: 0.0
  warmup_steps: 100
  logging_steps: 10
```

### 3. 设置环境变量

在运行训练前，我们需要修改`run_with_base_env.bat`文件中的环境变量，指向LogiQA训练数据和配置：

1. 打开`run_with_base_env.bat`文件
2. 找到环境变量设置部分，修改为：
   ```batch
   REM 设置环境变量
   set AXOLOTL_CONFIG_PATH=%PROJECT_ROOT%\config.yaml
   set MODEL_OUTPUT_DIR=%PROJECT_ROOT%\output\qwen-qlora-ft-logiqa
   set DATA_DIR=%PROJECT_ROOT%\data\logiqa_train.jsonl
   ```

### 4. 启动训练

使用run_with_base_env.bat批处理文件启动训练：

```bash
# 运行训练批处理文件
run_with_base_env.bat
```

该脚本会自动：
1. 激活conda base环境
2. 安装必要的依赖
3. 使用direct_train.py启动训练过程

训练完成后，模型检查点将保存在`output/qwen-qlora-ft-logiqa`目录中。

### 5. 监控训练进度

您可以通过以下方式监控训练进度：

- 查看命令行输出的损失值和评估指标
- 通过TensorBoard查看训练曲线（如果已启用）：
  ```bash
  tensorboard --logdir=../output/qwen-qlora-ft-logiqa/runs
  ```

## 评估流程

我们提供了两个脚本来帮助您评估Qwen模型在LogiQA上的表现：

1. `evaluate_logiqa.py` - Python评估脚本
2. `evaluate_logiqa.bat` - Windows批处理文件，提供交互式界面

### 使用批处理文件（推荐）

批处理文件提供了简单的交互式界面，您可以通过以下步骤使用：

1. 双击运行 `evaluate_logiqa.bat`
2. 从菜单中选择操作：
   - 选项1：下载LogiQA数据集（如果尚未下载）
   - 选项2：运行完整评估（全部样本）
   - 选项3：运行快速评估（50个样本，用于测试）
   - 选项4：查看最近的评估结果
   - 选项5：退出程序

### 手动运行Python脚本

如果您需要更灵活的配置，可以直接运行Python脚本：

```bash
python evaluate_logiqa.py --model_path="../output/qwen-qlora-ft-logiqa/checkpoint-3" --base_model="Qwen/Qwen-1_8B-Chat" --data_path="../data/logiqa.jsonl" --output_path="../output/logiqa_results.json" --use_4bit
```

参数说明：
- `--model_path`: 微调模型路径（LoRA适配器）
- `--base_model`: 基础模型名称
- `--data_path`: LogiQA数据集路径
- `--output_path`: 评估结果输出路径
- `--use_4bit`: 使用4bit量化加载模型，节省内存
- `--max_samples`: 限制评估样本数量（可选）
- `--device`: 指定运行设备（默认auto）

## 评估结果说明

评估完成后，脚本将生成一个JSON格式的结果文件，包含以下信息：

1. 模型与适配器信息
2. 整体准确率和评估样本数量
3. 每个样本的详细评估结果，包括：
   - 问题背景和内容
   - 选项列表
   - 正确答案
   - 模型预测答案
   - 模型的完整回复文本
   - 是否正确的标记

### 结果可视化

您还可以使用以下命令生成结果的可视化报告：

```bash
python visualize_results.py --results_path="../output/logiqa_results.json" --output_path="../output/logiqa_report.html"
```

## 性能对比参考

以下是一些常见模型在LogiQA上的表现参考：

| 模型                  | LogiQA准确率 |
|----------------------|------------|
| GPT-3.5-Turbo        | 34.9%      |
| GPT-4                | 57.2%      |
| Llama-2-70B-Chat     | 40.1%      |
| Qwen-14B-Chat        | 42.8%      |
| Qwen-7B-LoRA (微调后) | 38.2%      |
| Qwen-14B-LoRA (微调后)| 45.6%      |

您可以将我们微调后的模型结果与上述基准进行对比，评估微调效果。

## 可能的问题与解决方案

1. **数据集下载失败**
   - 可以手动从 GitHub 下载：https://github.com/csitfun/LogiEval/tree/main/Data/logiqa
   - 将下载的 `logiqa.jsonl` 放入 `data` 目录

2. **内存不足**
   - 确保使用 `--use_4bit` 参数启用量化
   - 减少 `--max_samples` 参数值
   - 使用更小的基础模型
   - 训练时减小批处理大小和梯度累积步数

3. **评估速度较慢**
   - 这是正常的，逻辑推理任务需要较长的处理时间
   - 可以先使用快速评估（选项3）进行测试

4. **训练损失不收敛**
   - 尝试降低学习率（比如2e-5）
   - 增加训练轮数
   - 检查数据预处理流程是否正确

## 进一步改进建议

1. **提示工程**:
   - 调整提示模板以提高性能
   - 实施思维链（Chain-of-Thought）策略，让模型先分析再给出答案

2. **训练策略**:
   - 针对逻辑推理任务使用特定的微调策略
   - 结合多个逻辑推理数据集进行联合训练
   - 使用两阶段训练：先在通用数据上微调，再在LogiQA上微调

3. **模型选择**:
   - 使用更大的模型版本（Qwen-14B或更大）
   - 尝试其他基础模型（如Llama-3）

4. **数据增强**:
   - 使用强大的LLM生成额外的逻辑推理训练样本
   - 通过难例挖掘找出模型表现不佳的样本类型，针对性增加训练数据 