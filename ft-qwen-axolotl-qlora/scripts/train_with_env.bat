@echo off
REM Qwen QLoRA微调脚本（使用环境变量）
REM 宇宙本论 v37.5

REM 设置conda环境（使用base环境）
SET CONDA_PATH=%USERPROFILE%\anaconda3
SET CONDA_ENV=base

echo 检查环境变量...
IF NOT DEFINED AXOLOTL_CONFIG_PATH (
    echo 环境变量AXOLOTL_CONFIG_PATH未设置，将使用默认值
) ELSE (
    echo 使用配置文件: %AXOLOTL_CONFIG_PATH%
)

IF NOT DEFINED MODEL_OUTPUT_DIR (
    echo 环境变量MODEL_OUTPUT_DIR未设置，将使用默认值
) ELSE (
    echo 输出目录: %MODEL_OUTPUT_DIR%
    if not exist "%MODEL_OUTPUT_DIR%" mkdir "%MODEL_OUTPUT_DIR%"
)

IF NOT DEFINED DATA_DIR (
    echo 环境变量DATA_DIR未设置，将使用默认值
) ELSE (
    echo 数据目录: %DATA_DIR%
)

echo 激活Conda base环境...
CALL "%CONDA_PATH%\Scripts\activate.bat" %CONDA_ENV%

echo 检查必要依赖...
pip install transformers peft bitsandbytes accelerate numpy datasets pyyaml --quiet

echo 开始训练...
python direct_train.py

echo 训练完成。 