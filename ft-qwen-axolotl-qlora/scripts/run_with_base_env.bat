@echo off
REM Qwen QLoRA微调一键启动脚本（使用conda base环境）
REM 宇宙本论 v37.5

REM 获取项目根目录
set SCRIPT_DIR=%~dp0
set PROJECT_ROOT=%SCRIPT_DIR%\..
set SCRIPT_DIR=%SCRIPT_DIR:~0,-1%

REM 设置环境变量
set AXOLOTL_CONFIG_PATH=%PROJECT_ROOT%\config.yaml
set MODEL_OUTPUT_DIR=%PROJECT_ROOT%\output\qwen-qlora-ft
set DATA_DIR=%PROJECT_ROOT%\data\conversation_sft.jsonl

REM 显示环境变量
echo 已设置以下环境变量:
echo 模型配置路径: %AXOLOTL_CONFIG_PATH%
echo 输出目录: %MODEL_OUTPUT_DIR%
echo 数据目录: %DATA_DIR%

REM 确保输出目录存在
if not exist "%MODEL_OUTPUT_DIR%" mkdir "%MODEL_OUTPUT_DIR%"

REM 设置conda环境
set CONDA_PATH=%USERPROFILE%\anaconda3
set CONDA_ENV=base

echo.
echo 正在激活Conda base环境...
call "%CONDA_PATH%\Scripts\activate.bat" %CONDA_ENV%

echo.
echo 检查必要依赖...
pip install transformers peft bitsandbytes accelerate numpy datasets pyyaml --quiet

echo.
echo 切换到脚本目录...
cd /d "%SCRIPT_DIR%"

echo.
echo 开始训练...
python direct_train.py

echo.
echo 训练完成。
pause 