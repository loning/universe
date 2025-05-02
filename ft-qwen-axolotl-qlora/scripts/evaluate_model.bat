@echo off
REM Qwen微调模型评估脚本
REM 宇宙本论 v37.5

REM 获取项目根目录
set SCRIPT_DIR=%~dp0
set PROJECT_ROOT=%SCRIPT_DIR%\..
set SCRIPT_DIR=%SCRIPT_DIR:~0,-1%

REM 设置环境变量
set MODEL_PATH=%PROJECT_ROOT%\output\qwen-qlora-ft\checkpoint-3
set BASE_MODEL=Qwen/Qwen-1_8B-Chat

REM 设置conda环境
set CONDA_PATH=%USERPROFILE%\anaconda3
set CONDA_ENV=base

echo.
echo 正在激活Conda base环境...
call "%CONDA_PATH%\Scripts\activate.bat" %CONDA_ENV%

echo.
echo 检查必要依赖...
pip install transformers peft bitsandbytes accelerate numpy torch --quiet

echo.
echo 切换到脚本目录...
cd /d "%SCRIPT_DIR%"

:menu
echo.
echo ===== Qwen 微调模型评估 =====
echo.
echo 1. 使用默认提示评估模型
echo 2. 进入交互式模式
echo 3. 使用自定义提示评估
echo 4. 退出
echo.
set /p choice=请选择操作 (1-4): 

if "%choice%"=="1" (
    echo.
    echo 使用默认提示评估模型...
    python evaluate_model.py --model_path="%MODEL_PATH%" --base_model="%BASE_MODEL%" --use_4bit
    goto menu
)

if "%choice%"=="2" (
    echo.
    echo 进入交互式模式...
    python evaluate_model.py --model_path="%MODEL_PATH%" --base_model="%BASE_MODEL%" --prompt="interactive" --use_4bit
    goto menu
)

if "%choice%"=="3" (
    echo.
    set /p custom_prompt=请输入自定义提示: 
    echo.
    echo 使用自定义提示评估模型...
    python evaluate_model.py --model_path="%MODEL_PATH%" --base_model="%BASE_MODEL%" --prompt="%custom_prompt%" --use_4bit
    goto menu
)

if "%choice%"=="4" (
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