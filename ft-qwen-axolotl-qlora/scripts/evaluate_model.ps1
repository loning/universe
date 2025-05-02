# Qwen微调模型评估脚本 (PowerShell版)
# 宇宙本论 v37.5

# 设置工作目录为脚本所在目录
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

# 设置项目目录和路径
$projectRoot = (Get-Item $scriptPath).Parent.FullName
$modelPath = Join-Path $projectRoot "output\qwen-qlora-ft\checkpoint-3"
$baseModel = "Qwen/Qwen-1_8B-Chat"

# 设置conda环境（如果需要）
$condaPath = "$env:USERPROFILE\anaconda3"
$condaEnv = "base"

# 尝试激活conda环境
try {
    Write-Host "尝试激活Conda base环境..." -ForegroundColor Yellow
    & "$condaPath\Scripts\activate.bat" $condaEnv
} catch {
    Write-Host "无法激活Conda环境，将使用当前Python环境" -ForegroundColor Red
}

# 安装必要依赖
Write-Host "检查并安装必要依赖..." -ForegroundColor Cyan
pip install transformers peft bitsandbytes accelerate numpy torch --quiet

function Show-Menu {
    Write-Host "`n===== Qwen 微调模型评估 =====" -ForegroundColor Green
    Write-Host
    Write-Host "1. 使用默认提示评估模型" -ForegroundColor Yellow
    Write-Host "2. 进入交互式模式" -ForegroundColor Yellow
    Write-Host "3. 使用自定义提示评估" -ForegroundColor Yellow
    Write-Host "4. 退出" -ForegroundColor Yellow
    Write-Host
}

function Run-Evaluation {
    param (
        [string]$prompt = "介绍一下宇宙本论的基本概念",
        [switch]$interactive
    )
    
    if ($interactive) {
        Write-Host "`n进入交互式模式..." -ForegroundColor Cyan
        python evaluate_model.py --model_path="$modelPath" --base_model="$baseModel" --prompt="interactive" --use_4bit
    } else {
        Write-Host "`n使用提示评估模型: $prompt" -ForegroundColor Cyan
        python evaluate_model.py --model_path="$modelPath" --base_model="$baseModel" --prompt="$prompt" --use_4bit
    }
}

# 主循环
do {
    Show-Menu
    $choice = Read-Host "请选择操作 (1-4)"
    
    switch ($choice) {
        "1" { Run-Evaluation }
        "2" { Run-Evaluation -interactive }
        "3" { 
            $customPrompt = Read-Host "请输入自定义提示"
            Run-Evaluation -prompt $customPrompt
        }
        "4" { 
            Write-Host "`n谢谢使用!" -ForegroundColor Green
            return
        }
        default { Write-Host "`n无效选择，请重试." -ForegroundColor Red }
    }
} while ($true) 