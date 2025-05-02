@echo off
chcp 65001 > nul
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
echo 2. 在LogiQA上评估微调模型
echo 3. 在LogiQA上评估基准模型（未微调）
echo 4. 比较评估结果
echo 5. 下载所需数据
echo 6. 退出
echo.
choice /c 123456 /n /m "请选择操作 (1-6): "

if errorlevel 6 goto exit_program
if errorlevel 5 goto download_menu
if errorlevel 4 goto compare_results
if errorlevel 3 goto evaluate_baseline
if errorlevel 2 goto evaluation
if errorlevel 1 goto training

:training
echo.
echo 训练模型菜单

:train_menu
echo.
echo 1. 使用direct_train.py训练（不依赖Axolotl）
echo 2. 使用Axolotl训练（使用train_cosmos.bat）
echo 3. 返回主菜单
echo.
choice /c 123 /n /m "请选择训练方式 (1-3): "

if errorlevel 3 goto menu
if errorlevel 2 goto axolotl_train
if errorlevel 1 goto direct_train

:direct_train
echo.
echo 启动direct_train.py训练...
call direct_train.bat
goto train_menu

:axolotl_train
echo.
echo 启动Axolotl训练...
call train_cosmos.bat
goto train_menu

:evaluation
echo.
echo 启动微调模型评估...
call evaluate_logiqa.bat
goto menu

:evaluate_baseline
echo.
echo 启动基准模型评估...
call evaluate_baseline.bat
goto menu

:compare_results
echo.
echo 启动评估结果比较工具...
call compare_results.bat
goto menu

:download_menu
echo.
echo 数据下载菜单

:data_menu
echo.
echo 1. 下载LogiQA数据集
echo 2. 返回主菜单
echo.
choice /c 12 /n /m "请选择操作 (1-2): "

if errorlevel 2 goto menu
if errorlevel 1 goto download_logiqa

:download_logiqa
echo.
echo 下载LogiQA数据集...
python download_data.py --dataset=logiqa --output_dir="%PROJECT_ROOT%\data"
goto data_menu

:exit_program
echo.
echo 感谢使用!
goto end

:end
echo. 