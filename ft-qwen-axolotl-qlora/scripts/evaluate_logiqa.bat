@echo off
chcp 65001 > nul
REM Qwen微调模型LogiQA评估脚本
REM 宇宙本论 v37.5

REM 获取项目根目录
set SCRIPT_DIR=%~dp0
set PROJECT_ROOT=%SCRIPT_DIR%..
set SCRIPT_DIR=%SCRIPT_DIR:~0,-1%

REM 清理路径中的多余斜杠
set PROJECT_ROOT=%PROJECT_ROOT:\\=\%

REM 设置环境变量
set MODEL_PATH=%PROJECT_ROOT%\output\qwen-qlora-ft\checkpoint-3
set BASE_MODEL=Qwen/Qwen-1_8B-Chat
set DATA_PATH=%PROJECT_ROOT%\data\logiqa_test.jsonl
set OUTPUT_PATH=%PROJECT_ROOT%\output\logiqa_results.json
set QUICK_OUTPUT_PATH=%PROJECT_ROOT%\output\logiqa_results_quick.json
set "PYTHONIOENCODING=utf-8"

REM 显示设置信息
echo 项目根目录: %PROJECT_ROOT%
echo 评估结果输出路径: %OUTPUT_PATH%

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
echo 4. 生成评估报告
echo 5. 返回上级菜单
echo.
choice /c 12345 /n /m "请选择操作 (1-5): "

if errorlevel 5 goto end
if errorlevel 4 goto generate_report
if errorlevel 3 goto quick_eval
if errorlevel 2 goto full_eval
if errorlevel 1 goto download_logiqa

:download_logiqa
echo.
echo 下载LogiQA数据集...
python download_data.py --dataset=logiqa --output_dir="%PROJECT_ROOT%\data"
goto menu

:full_eval
echo.
echo 运行完整评估...
python evaluate_logiqa.py --model_path="%MODEL_PATH%" --base_model="%BASE_MODEL%" --data_path="%DATA_PATH%" --output_path="%OUTPUT_PATH%" --device=cuda

REM 检查评估结果是否生成成功
if exist "%OUTPUT_PATH%" (
    echo.
    echo 评估结果已保存到: %OUTPUT_PATH%
) else (
    echo.
    echo 警告: 未找到评估结果文件。评估可能未成功完成。
)

echo.
echo 评估完成，是否生成报告？(Y/N)
choice /c YN /n /m "选择 (Y/N): "
if errorlevel 2 goto menu
if errorlevel 1 goto generate_report_for_full
goto menu

:quick_eval
echo.
echo 运行快速评估（50个样本）...
python evaluate_logiqa.py --model_path="%MODEL_PATH%" --base_model="%BASE_MODEL%" --data_path="%DATA_PATH%" --output_path="%QUICK_OUTPUT_PATH%" --max_samples=50 --device=cuda

REM 检查评估结果是否生成成功
if exist "%QUICK_OUTPUT_PATH%" (
    echo.
    echo 快速评估结果已保存到: %QUICK_OUTPUT_PATH%
) else (
    echo.
    echo 警告: 未找到快速评估结果文件。评估可能未成功完成。
)

echo.
echo 评估完成，是否生成报告？(Y/N)
choice /c YN /n /m "选择 (Y/N): "
if errorlevel 2 goto menu
if errorlevel 1 goto generate_report_for_quick
goto menu

:generate_report
echo.
echo 生成评估报告...
call generate_report.bat
goto menu

:generate_report_for_full
echo.
echo 生成完整评估报告...

REM 检查评估结果文件是否存在
if not exist "%OUTPUT_PATH%" (
    echo 错误: 完整评估结果文件不存在: %OUTPUT_PATH%
    echo 请先运行完整评估或检查文件路径。
    goto menu
)

python generate_report.py --input_path="%OUTPUT_PATH%" --output_dir="%PROJECT_ROOT%\output\reports" --format=both --title="LogiQA完整评估报告"
if %ERRORLEVEL% EQU 0 (
    echo 报告生成成功！
    explorer "%PROJECT_ROOT%\output\reports"
) else (
    echo 报告生成失败，错误代码: %ERRORLEVEL%
)
goto menu

:generate_report_for_quick
echo.
echo 生成快速评估报告...

REM 检查评估结果文件是否存在
if not exist "%QUICK_OUTPUT_PATH%" (
    echo 错误: 快速评估结果文件不存在: %QUICK_OUTPUT_PATH%
    echo 请先运行快速评估或检查文件路径。
    goto menu
)

python generate_report.py --input_path="%QUICK_OUTPUT_PATH%" --output_dir="%PROJECT_ROOT%\output\reports" --format=both --title="LogiQA快速评估报告"
if %ERRORLEVEL% EQU 0 (
    echo 报告生成成功！
    explorer "%PROJECT_ROOT%\output\reports"
) else (
    echo 报告生成失败，错误代码: %ERRORLEVEL%
)
goto menu

:end
echo.
pause 