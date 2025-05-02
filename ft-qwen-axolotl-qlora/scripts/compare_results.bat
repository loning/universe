@echo off
chcp 65001 > nul
REM LogiQA评估结果比较脚本
REM 宇宙本论 v37.5

REM 启用延迟变量扩展
setlocal enabledelayedexpansion

REM 获取项目根目录
set SCRIPT_DIR=%~dp0
set PROJECT_ROOT=%SCRIPT_DIR%..
set SCRIPT_DIR=%SCRIPT_DIR:~0,-1%

REM 清理路径中的多余斜杠
set PROJECT_ROOT=%PROJECT_ROOT:\\=\%

REM 设置环境变量
set RESULTS_DIR=%PROJECT_ROOT%\output
set OUTPUT_DIR=%PROJECT_ROOT%\output\reports
set BASELINE_FILE=%PROJECT_ROOT%\output\logiqa_results_baseline.json
set BASELINE_FILE_QUICK=%PROJECT_ROOT%\output\logiqa_results_baseline_quick.json
set "PYTHONIOENCODING=utf-8"

REM 显示设置信息
echo 项目根目录: %PROJECT_ROOT%
echo 评估结果目录: %RESULTS_DIR%
echo 报告输出目录: %OUTPUT_DIR%

REM 设置conda环境
set CONDA_PATH=%USERPROFILE%\anaconda3
set CONDA_ENV=base

echo.
echo 正在激活Conda base环境...
call "%CONDA_PATH%\Scripts\activate.bat" %CONDA_ENV%

echo.
echo 检查必要依赖...
pip install matplotlib numpy --quiet

echo.
echo 切换到脚本目录...
cd /d "%SCRIPT_DIR%"

:menu
echo.
echo ===== LogiQA评估结果比较工具 =====
echo.
echo 1. 比较所有评估结果
echo 2. 与自定义基准模型比较
echo 3. 与默认基准模型比较（未微调的Qwen模型）
echo 4. 返回上级菜单
echo.
choice /c 1234 /n /m "请选择操作 (1-4): "

if errorlevel 4 goto end
if errorlevel 3 goto compare_with_default_baseline
if errorlevel 2 goto compare_with_baseline
if errorlevel 1 goto compare_all

:compare_all
echo.
echo 比较所有可用的评估结果...
python compare_results.py --results_dir="%RESULTS_DIR%" --output_dir="%OUTPUT_DIR%" --title="LogiQA评估结果综合比较"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo 比较报告生成成功！
    explorer "%OUTPUT_DIR%"
) else (
    echo.
    echo 比较报告生成失败，错误代码: %ERRORLEVEL%
)
goto menu

:compare_with_baseline
echo.
echo 请选择基准模型的评估结果文件:

REM 列出所有可能的评估结果文件
set num=1
set files=
for %%f in ("%RESULTS_DIR%\logiqa_results*.json") do (
    echo !num!. %%~nxf
    set "files[!num!]=%%f"
    set /a num+=1
)

REM 如果没有找到文件
if !num!==1 (
    echo 没有找到评估结果文件。请先运行评估脚本。
    goto menu
)

echo.
set /p baseline_choice="请输入基准模型的编号: "

REM 验证输入
if !baseline_choice! LSS 1 (
    echo 无效的选择。
    goto compare_with_baseline
)
if !baseline_choice! GEQ !num! (
    echo 无效的选择。
    goto compare_with_baseline
)

set BASELINE_FILE=!files[%baseline_choice%]!
echo.
echo 将使用 !BASELINE_FILE! 作为基准模型。

echo.
echo 正在生成比较报告...
python compare_results.py --results_dir="%RESULTS_DIR%" --baseline_path="!BASELINE_FILE!" --output_dir="%OUTPUT_DIR%" --title="与基准模型比较报告"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo 比较报告生成成功！
    explorer "%OUTPUT_DIR%"
) else (
    echo.
    echo 比较报告生成失败，错误代码: %ERRORLEVEL%
)
goto menu

:compare_with_default_baseline
echo.
echo 使用未微调的Qwen模型作为基准...

REM 查找基准模型的评估结果文件
set FOUND_BASELINE=0
echo 正在查找基准模型评估结果...

REM 尝试不同的可能基准文件名
if exist "%BASELINE_FILE%" (
    set FOUND_BASELINE=1
    set CURRENT_BASELINE_FILE=%BASELINE_FILE%
    echo 找到基准模型评估结果: %BASELINE_FILE%
) else if exist "%BASELINE_FILE_QUICK%" (
    set FOUND_BASELINE=1
    set CURRENT_BASELINE_FILE=%BASELINE_FILE_QUICK%
    echo 找到基准模型快速评估结果: %BASELINE_FILE_QUICK%
) else (
    REM 尝试在结果目录中查找包含"baseline"的文件
    for %%f in ("%RESULTS_DIR%\*baseline*.json") do (
        set FOUND_BASELINE=1
        set CURRENT_BASELINE_FILE=%%f
        echo 找到可能的基准模型结果: %%f
        goto baseline_found
    )
)

:baseline_found
if %FOUND_BASELINE%==0 (
    echo 错误: 未找到基准模型评估结果。
    echo 请先运行基准模型评估（主菜单选项3），然后再尝试比较。
    goto menu
)

echo.
echo 将使用 %CURRENT_BASELINE_FILE% 作为基准模型结果。

echo.
echo 选择要与基准模型比较的微调模型结果文件:

REM 列出所有微调模型评估结果文件，但排除基准模型结果
set num=1
set ftuned_files=
for %%f in ("%RESULTS_DIR%\logiqa_results*.json") do (
    if not "%%f"=="%CURRENT_BASELINE_FILE%" (
        if not "%%~nxf"=="logiqa_results_baseline.json" (
            if not "%%~nxf"=="logiqa_results_baseline_quick.json" (
                echo !num!. %%~nxf
                set "ftuned_files[!num!]=%%f"
                set /a num+=1
            )
        )
    )
)

REM 如果没有找到微调模型评估文件
if !num!==1 (
    echo 没有找到微调模型评估结果文件。请先运行微调模型评估。
    goto menu
)

echo.
set /p ftuned_choice="请输入微调模型的编号: "

REM 验证输入
if !ftuned_choice! LSS 1 (
    echo 无效的选择。
    goto compare_with_default_baseline
)
if !ftuned_choice! GEQ !num! (
    echo 无效的选择。
    goto compare_with_default_baseline
)

set FTUNED_FILE=!ftuned_files[%ftuned_choice%]!
echo.
echo 将比较微调模型 !FTUNED_FILE! 与基准模型 %CURRENT_BASELINE_FILE%

echo.
echo 正在生成比较报告...
python compare_results.py --results_dir="%RESULTS_DIR%" --include_pattern="*" --baseline_path="%CURRENT_BASELINE_FILE%" --output_dir="%OUTPUT_DIR%" --title="微调模型vs基准模型比较报告"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo 比较报告生成成功！
    explorer "%OUTPUT_DIR%"
) else (
    echo.
    echo 比较报告生成失败，错误代码: %ERRORLEVEL%
    echo 尝试备用方法...
    
    echo 创建临时目录，复制两个文件用于比较...
    mkdir "%RESULTS_DIR%\temp_compare" 2>nul
    copy "%CURRENT_BASELINE_FILE%" "%RESULTS_DIR%\temp_compare\baseline.json" >nul
    copy "!FTUNED_FILE!" "%RESULTS_DIR%\temp_compare\finetuned.json" >nul
    
    python compare_results.py --results_dir="%RESULTS_DIR%\temp_compare" --output_dir="%OUTPUT_DIR%" --title="微调模型vs基准模型比较报告"
    
    if %ERRORLEVEL% EQU 0 (
        echo 备用方法比较报告生成成功！
        explorer "%OUTPUT_DIR%"
    ) else (
        echo 比较报告生成仍然失败。
    )
)
goto menu

:end
echo 返回主菜单...
endlocal 