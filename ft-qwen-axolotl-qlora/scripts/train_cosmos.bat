@echo off
chcp 65001 > nul
REM Qwen QLoRA微调一键启动脚本（使用cosmos_ontology数据集）
REM 宇宙本论 v37.5

REM 获取项目根目录
set SCRIPT_DIR=%~dp0
set PROJECT_ROOT=%SCRIPT_DIR%\\..
set SCRIPT_DIR=%SCRIPT_DIR:~0,-1%

REM 设置环境变量
set AXOLOTL_CONFIG_PATH=%PROJECT_ROOT%\\config.yaml
set MODEL_OUTPUT_DIR=%PROJECT_ROOT%\\output\\qwen-qlora-ft
set DATA_DIR=%PROJECT_ROOT%\\data\\cosmos_ontology_alpaca.jsonl
set PYTHONPATH=C:\\Users\\USER\\cursor\\axolotl;%PYTHONPATH%
set TOKENIZERS_PARALLELISM=true
set WANDB_DISABLED=true
set CUDA_VISIBLE_DEVICES=0
set PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:128

REM 显示环境变量
echo 已设置以下环境变量:
echo 模型配置路径: %AXOLOTL_CONFIG_PATH%
echo 输出目录: %MODEL_OUTPUT_DIR%
echo 数据目录: %DATA_DIR%
echo Python路径: %PYTHONPATH%
echo CUDA设备: %CUDA_VISIBLE_DEVICES%
echo CUDA内存分配: %PYTORCH_CUDA_ALLOC_CONF%

REM 确保输出目录存在
if not exist "%MODEL_OUTPUT_DIR%" mkdir "%MODEL_OUTPUT_DIR%"

REM 设置conda环境
set CONDA_PATH=%USERPROFILE%\\anaconda3
set CONDA_ENV=base

echo.
echo 正在激活Conda base环境...
call "%CONDA_PATH%\\Scripts\\activate.bat" %CONDA_ENV%

echo.
echo 检查必要依赖...
pip install -q transformers>=4.35.0 peft>=0.7.0 bitsandbytes>=0.41.0 accelerate>=0.23.0 datasets>=2.12.0

echo.
echo 检查数据文件...
if exist "%DATA_DIR%" (
    echo 数据文件存在: %DATA_DIR%
    python -c "import json; print(f'样本数量: {sum(1 for _ in open('%DATA_DIR%', 'r', encoding='utf-8'))}')"
) else (
    echo 错误: 数据文件不存在: %DATA_DIR%
    goto end
)

echo.
echo 检查CUDA可用性...
python -c "import torch; print(f'CUDA可用: {torch.cuda.is_available()}')"
python -c "import torch; print(f'可用GPU数量: {torch.cuda.device_count()}')"
python -c "import torch; print(f'当前设备: {torch.cuda.get_device_name(0) if torch.cuda.is_available() else \"CPU\"}')"
python -c "import torch; print(f'CUDA版本: {torch.version.cuda}')"
python -c "import torch; free_mem = torch.cuda.mem_get_info()[0]/1024**3 if torch.cuda.is_available() else 0; print(f'GPU可用内存: {free_mem:.2f} GB')"

echo.
echo 开始训练...
python -c "import sys; print(f'Python路径: {sys.path}')"
python -c "import os; print(f'当前工作目录: {os.getcwd()}')"

echo.
echo 使用Axolotl训练...
set PYTHONPATH=C:\\Users\\USER\\cursor\\axolotl;%PYTHONPATH%
cd "%PROJECT_ROOT%"
python -m axolotl.cli.train %AXOLOTL_CONFIG_PATH% --report_to tensorboard --debug

echo.
echo 训练完成!

:end
pause 