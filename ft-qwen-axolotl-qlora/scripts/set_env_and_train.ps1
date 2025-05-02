# 设置宇宙本论QWen微调的环境变量
# 宇宙本论 v37.5

# 获取当前目录路径
$currentDir = Get-Location
$projectRoot = Split-Path -Parent $currentDir

# 设置项目相关路径
$configPath = Join-Path $projectRoot "ft-qwen-axolotl-qlora\config.yaml"
$outputDir = Join-Path $projectRoot "ft-qwen-axolotl-qlora\output\qwen-qlora-ft"
$dataDir = Join-Path $projectRoot "ft-qwen-axolotl-qlora\data\conversation_sft.jsonl"

# 设置环境变量
$env:AXOLOTL_CONFIG_PATH = $configPath
$env:MODEL_OUTPUT_DIR = $outputDir
$env:DATA_DIR = $dataDir

# 显示设置的环境变量
Write-Host "已设置以下环境变量:" -ForegroundColor Green
Write-Host "AXOLOTL_CONFIG_PATH = $env:AXOLOTL_CONFIG_PATH" -ForegroundColor Cyan
Write-Host "MODEL_OUTPUT_DIR = $env:MODEL_OUTPUT_DIR" -ForegroundColor Cyan
Write-Host "DATA_DIR = $env:DATA_DIR" -ForegroundColor Cyan

# 使用conda base环境
$condaPath = "$env:USERPROFILE\anaconda3"
Write-Host "`n使用Conda base环境:" -ForegroundColor Green
Write-Host "在运行脚本前，请确保已激活conda base环境:" -ForegroundColor Yellow
Write-Host "   & '$condaPath\Scripts\activate.bat' base"

Write-Host "`n环境变量已设置完毕！现在您可以：" -ForegroundColor Green
Write-Host "1. 运行训练脚本：" -ForegroundColor Yellow
Write-Host "   cd $projectRoot\ft-qwen-axolotl-qlora\scripts"
Write-Host "   python direct_train.py"
Write-Host "`n2. 检查配置参数：" -ForegroundColor Yellow
Write-Host "   cat $env:AXOLOTL_CONFIG_PATH"
Write-Host "`n3. 查看训练输出目录：" -ForegroundColor Yellow
Write-Host "   ls $env:MODEL_OUTPUT_DIR"

# 保持当前环境变量，供用户在后续操作中使用
Write-Host "`n环境变量将在当前终端会话中保持有效。" -ForegroundColor Magenta 