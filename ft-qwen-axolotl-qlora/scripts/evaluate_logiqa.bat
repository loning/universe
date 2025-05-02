@echo off
REM Qwen微调模型LogiQA评估脚本
REM 宇宙本论 v37.5

REM 获取项目根目录
set SCRIPT_DIR=%~dp0
set PROJECT_ROOT=%SCRIPT_DIR%\..
set SCRIPT_DIR=%SCRIPT_DIR:~0,-1%

REM 设置环境变量
set MODEL_PATH=%PROJECT_ROOT%\output\qwen-qlora-ft\checkpoint-3
set BASE_MODEL=Qwen/Qwen-1_8B-Chat
set DATA_PATH=%PROJECT_ROOT%\data\logiqa_test.jsonl
set OUTPUT_PATH=%PROJECT_ROOT%\output\logiqa_results.json

REM 设置conda环境
set CONDA_PATH=%USERPROFILE%\anaconda3
set CONDA_ENV=base

echo.
echo 正在激活Conda base环境...
call "%CONDA_PATH%\Scripts\activate.bat" %CONDA_ENV%

echo.
echo 检查必要依赖...
pip install transformers peft bitsandbytes accelerate numpy torch tqdm requests --quiet

echo.
echo 切换到脚本目录...
cd /d "%SCRIPT_DIR%"

:menu
echo.
echo ===== Qwen 微调模型 LogiQA 评估 =====
echo.
echo 1. 下载LogiQA数据集（如果需要）
echo 2. 运行完整评估
echo 3. 运行快速评估（50个样本）
echo 4. 查看最近评估结果
echo 5. 退出
echo.
set /p choice=请选择操作 (1-5): 

if "%choice%"=="1" (
    echo.
    echo 正在下载LogiQA数据集...
    python download_logiqa.py --output_dir="%PROJECT_ROOT%\data"
    goto menu
)

if "%choice%"=="2" (
    echo.
    echo 正在运行完整LogiQA评估...
    python evaluate_logiqa.py --model_path="%MODEL_PATH%" --base_model="%BASE_MODEL%" --data_path="%DATA_PATH%" --output_path="%OUTPUT_PATH%" --use_4bit
    goto menu
)

if "%choice%"=="3" (
    echo.
    echo 正在运行快速LogiQA评估（50个样本）...
    python evaluate_logiqa.py --model_path="%MODEL_PATH%" --base_model="%BASE_MODEL%" --data_path="%DATA_PATH%" --output_path="%PROJECT_ROOT%\output\logiqa_results_quick.json" --use_4bit --max_samples=50
    goto menu
)

if "%choice%"=="4" (
    echo.
    echo 查看最近评估结果...
    
    if exist "%OUTPUT_PATH%" (
        echo 评估结果文件存在，正在提取关键信息...
        python -c "import json; data=json.load(open('%OUTPUT_PATH%', 'r', encoding='utf-8')); print(f'模型: {data[\"model\"]}\nAdapter: {data[\"adapter\"]}\n准确率: {data[\"accuracy\"]:.4f} ({data[\"correct_samples\"]}/{data[\"samples_evaluated\"]})')"
    ) else (
        echo 未找到评估结果文件，请先运行评估。
    )
    
    goto menu
)

if "%choice%"=="5" (
    echo.
    echo 谢谢使用!
    goto end
)

echo.
echo 无效选择，请重试.
goto menu

:end
echo.
pause 