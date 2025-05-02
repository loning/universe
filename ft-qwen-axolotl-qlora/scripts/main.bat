@echo off
REM Qwen微调与评估主入口脚本
REM 宇宙本论 v37.5

REM 获取项目根目录
set SCRIPT_DIR=%~dp0
set PROJECT_ROOT=%SCRIPT_DIR%\..
set SCRIPT_DIR=%SCRIPT_DIR:~0,-1%

echo.
echo 切换到脚本目录...
cd /d "%SCRIPT_DIR%"

:menu
cls
echo ===================================
echo    Qwen模型微调与LogiQA评估系统
echo    宇宙本论 v37.5
echo ===================================
echo.
echo 1. 使用宇宙本论数据训练模型
echo 2. 在LogiQA上评估模型
echo 3. 下载所需数据
echo 4. 退出
echo.
set /p choice=请选择操作 (1-4): 

if "%choice%"=="1" (
    echo.
    echo 启动模型训练...
    call train_cosmos.bat
    goto menu
)

if "%choice%"=="2" (
    echo.
    echo 启动模型评估...
    call evaluate_logiqa.bat
    goto menu
)

if "%choice%"=="3" (
    echo.
    echo 数据下载菜单
    
    :data_menu
    echo.
    echo 1. 下载LogiQA数据集
    echo 2. 返回主菜单
    echo.
    set /p data_choice=请选择操作 (1-2): 
    
    if "%data_choice%"=="1" (
        echo.
        echo 下载LogiQA数据集...
        python download_data.py --dataset=logiqa --output_dir="%PROJECT_ROOT%\data"
        goto data_menu
    )
    
    if "%data_choice%"=="2" (
        goto menu
    )
    
    echo.
    echo 无效选择，请重试.
    goto data_menu
)

if "%choice%"=="4" (
    echo.
    echo 感谢使用!
    goto end
)

echo.
echo 无效选择，请重试.
goto menu

:end
echo. 