# Qwen QLoRA微调PowerShell脚本
# 宇宙本论 v37.5

# 设置工作目录为脚本所在目录
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

# 设置项目目录和环境变量
$projectRoot = (Get-Item $scriptPath).Parent.FullName
$configPath = Join-Path $projectRoot "config.yaml"
$outputDir = Join-Path $projectRoot "output/qwen-qlora-ft"
$dataDir = Join-Path $projectRoot "data/conversation_sft.jsonl"

# 设置环境变量
$env:AXOLOTL_CONFIG_PATH = $configPath
$env:MODEL_OUTPUT_DIR = $outputDir
$env:DATA_DIR = $dataDir

Write-Host "已设置以下环境变量:" -ForegroundColor Green
Write-Host "模型配置路径: $env:AXOLOTL_CONFIG_PATH"
Write-Host "输出目录: $env:MODEL_OUTPUT_DIR"
Write-Host "数据目录: $env:DATA_DIR"

# 确保输出目录存在
if (-not (Test-Path $outputDir)) {
    Write-Host "创建输出目录: $outputDir" -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

# 设置conda环境（使用base环境）
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
pip install transformers peft bitsandbytes accelerate numpy datasets pyyaml --quiet

# 开始训练
Write-Host "开始训练..." -ForegroundColor Green
python direct_train.py

Write-Host "训练完成！" -ForegroundColor Green 