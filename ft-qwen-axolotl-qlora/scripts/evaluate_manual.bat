@echo off
chcp 65001 > nul
REM Qwen微调模型LogiQA手动评估脚本（直接运行，不需要菜单交互）
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
set "PYTHONIOENCODING=utf-8"

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

echo.
echo 检查数据文件...
if exist "%DATA_PATH%" (
    echo LogiQA数据文件存在: %DATA_PATH%
    python -c "import json; data_path = r'%DATA_PATH%'; print(f'样本数量: {sum(1 for _ in open(data_path, \"r\", encoding=\"utf-8\"))}')"
) else (
    echo 警告: LogiQA数据文件不存在，将尝试下载
    python download_data.py --dataset=logiqa --output_dir="%PROJECT_ROOT%\data"
)

echo.
echo 运行快速评估（50个样本）...
python evaluate_logiqa.py --model_path="%MODEL_PATH%" --base_model="%BASE_MODEL%" --data_path="%DATA_PATH%" --output_path="%PROJECT_ROOT%\output\logiqa_results_quick.json" --max_samples=50 --device=cuda

echo.
echo 评估完成！结果保存在 %PROJECT_ROOT%\output\logiqa_results_quick.json

:end
pause 