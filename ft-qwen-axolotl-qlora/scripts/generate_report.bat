@echo off
chcp 65001 > nul
REM LogiQA评估结果报告生成脚本
REM 宇宙本论 v37.5

REM 启用延迟变量扩展
setlocal enabledelayedexpansion

REM 获取项目根目录 - 确保路径格式正确
set SCRIPT_DIR=%~dp0
set PROJECT_ROOT=%SCRIPT_DIR%..
set SCRIPT_DIR=%SCRIPT_DIR:~0,-1%

REM 清理路径中的多余斜杠
set PROJECT_ROOT=%PROJECT_ROOT:\\=\%

REM 设置环境变量
set OUTPUT_DIR=%PROJECT_ROOT%\output\reports
set RESULTS_DIR=%PROJECT_ROOT%\output
set "PYTHONIOENCODING=utf-8"

REM 检查输出目录是否存在，如果不存在则创建
if not exist "%OUTPUT_DIR%" (
    mkdir "%OUTPUT_DIR%"
    echo 已创建报告输出目录: %OUTPUT_DIR%
)

echo.
echo 项目根目录: %PROJECT_ROOT%
echo 结果目录: %RESULTS_DIR%
echo 报告输出目录: %OUTPUT_DIR%

REM 设置conda环境
set CONDA_PATH=%USERPROFILE%\anaconda3
set CONDA_ENV=base

echo.
echo 正在激活Conda base环境...
call "%CONDA_PATH%\Scripts\activate.bat" %CONDA_ENV%

echo.
echo 检查必要依赖...
pip install -q matplotlib numpy

echo.
echo 切换到脚本目录...
cd /d "%SCRIPT_DIR%"

:menu
echo.
echo ===== LogiQA评估结果报告生成 =====
echo.
echo 可用的评估结果:

REM 检查结果目录是否存在
if not exist "%RESULTS_DIR%" (
    echo 警告: 评估结果目录不存在: %RESULTS_DIR%
    echo 将使用固定选项...
    goto default_options
)

REM 列出所有可能的评估结果文件
set num=1
set files=
for %%f in ("%RESULTS_DIR%\logiqa_results*.json") do (
    echo !num!. %%~nxf ^(%%f^)
    set "files=!files!,%%f"
    set /a num+=1
)

REM 如果没有找到文件，则使用固定选项
if !num!==1 (
    echo 没有找到评估结果文件，将使用默认选项...
    
    :default_options
    echo 1. logiqa_results.json
    echo 2. logiqa_results_quick.json
    echo 3. 手动输入结果文件路径
    echo.
    choice /c 123 /n /m "请选择评估结果文件 (1-3): "
    
    if errorlevel 3 goto manual_input
    if errorlevel 2 goto use_file2
    if errorlevel 1 goto use_file1
) else (
    REM 添加手动输入选项
    set /a last_option=!num!
    echo !last_option!. 手动输入结果文件路径
    
    echo.
    REM 创建动态选择选项
    set "choices="
    for /l %%i in (1,1,!last_option!) do set "choices=!choices!%%i"
    choice /c !choices! /n /m "请选择评估结果文件 (1-!last_option!): "
    
    set /a choice_result=%errorlevel%
    if !choice_result!==!last_option! goto manual_input
    
    REM 使用选择的文件
    set count=1
    for %%f in ("%RESULTS_DIR%\logiqa_results*.json") do (
        if !count!==!choice_result! (
            set INPUT_FILE=%%f
            goto check_file
        )
        set /a count+=1
    )
)

:use_file1
set INPUT_FILE=%RESULTS_DIR%\logiqa_results.json
goto check_file

:use_file2
set INPUT_FILE=%RESULTS_DIR%\logiqa_results_quick.json
goto check_file

:manual_input
echo.
echo 请输入评估结果文件的完整路径:
echo 例如: C:\Users\USER\cursor\universe\ft-qwen-axolotl-qlora\output\logiqa_results.json
echo.
set /p INPUT_FILE="路径: "
goto check_file

:check_file
echo.
echo 检查文件 !INPUT_FILE! 是否存在...
if not exist "!INPUT_FILE!" (
    echo 错误: 文件 !INPUT_FILE! 不存在
    echo.
    
    REM 检查是否有评估结果
    set result_found=0
    if exist "%RESULTS_DIR%\logiqa_results.json" (
        echo 找到评估结果: %RESULTS_DIR%\logiqa_results.json
        set INPUT_FILE=%RESULTS_DIR%\logiqa_results.json
        set result_found=1
    ) else if exist "%RESULTS_DIR%\logiqa_results_quick.json" (
        echo 找到快速评估结果: %RESULTS_DIR%\logiqa_results_quick.json
        set INPUT_FILE=%RESULTS_DIR%\logiqa_results_quick.json
        set result_found=1
    )
    
    if !result_found!==1 (
        goto generate_report
    ) else (
        echo 未找到任何评估结果文件。
        echo 请先运行评估脚本生成结果，或手动输入正确的文件路径。
        goto manual_input
    )
)

:generate_report
echo.
echo 将使用以下结果文件生成报告:
echo !INPUT_FILE!

REM 确保输出目录存在
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

echo.
echo 正在生成报告...
python generate_report.py --input_path="!INPUT_FILE!" --output_dir="%OUTPUT_DIR%" --format=both

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo 报告生成失败，错误代码: %ERRORLEVEL%
    echo 尝试查找评估结果文件...
    
    if exist "%PROJECT_ROOT%\output\logiqa_results.json" (
        echo 找到评估结果: %PROJECT_ROOT%\output\logiqa_results.json
        set INPUT_FILE=%PROJECT_ROOT%\output\logiqa_results.json
        goto retry_generate
    ) else if exist "%PROJECT_ROOT%\output\logiqa_results_quick.json" (
        echo 找到快速评估结果: %PROJECT_ROOT%\output\logiqa_results_quick.json
        set INPUT_FILE=%PROJECT_ROOT%\output\logiqa_results_quick.json
        goto retry_generate
    ) else (
        echo 未找到任何评估结果文件。
        echo 请先运行评估脚本生成结果，然后再生成报告。
    )
) else (
    echo.
    echo 报告生成完成!
    echo 报告保存在: %OUTPUT_DIR%
    
    REM 打开报告目录
    explorer "%OUTPUT_DIR%"
)

goto end

:retry_generate
echo.
echo 重试生成报告...
python generate_report.py --input_path="!INPUT_FILE!" --output_dir="%OUTPUT_DIR%" --format=both

echo.
echo 报告生成完成!
echo 报告保存在: %OUTPUT_DIR%

REM 打开报告目录
explorer "%OUTPUT_DIR%"

:end
endlocal
pause 