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
echo 4. 返回上级菜单
echo.
set /p choice=请选择操作 (1-4): 

if "%choice%"=="1" (
    echo.
    echo 下载LogiQA数据集...
    python download_data.py --dataset=logiqa --output_dir="%PROJECT_ROOT%\data"
    goto menu
)

if "%choice%"=="2" (
    echo.
    echo 运行完整评估...
    python evaluate_logiqa.py --model_path="%MODEL_PATH%" --base_model="%BASE_MODEL%" --data_path="%DATA_PATH%" --output_path="%OUTPUT_PATH%" --device=cuda
    goto menu
)

if "%choice%"=="3" (
    echo.
    echo 运行快速评估（50个样本）...
    python evaluate_logiqa.py --model_path="%MODEL_PATH%" --base_model="%BASE_MODEL%" --data_path="%DATA_PATH%" --output_path="%PROJECT_ROOT%\output\logiqa_results_quick.json" --max_samples=50 --device=cuda
    goto menu
)

if "%choice%"=="4" (
    goto end
)

echo.
echo 无效选择，请重试.
goto menu

:end
echo.
pause 