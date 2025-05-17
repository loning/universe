#!/bin/bash
# 为CHEM-JCTC-060论文准备提交包

# 确保脚本在任何错误时停止
set -e

# 目录定义
PAPER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PDF_DIR="${PAPER_DIR}/build/pdf"
SUBMISSION_DIR="${PAPER_DIR}/build/submission"
LATEX_DIR="${PAPER_DIR}/build/latex"
TEMP_DIR="${PAPER_DIR}/temp"

# 创建必要的目录
mkdir -p "${SUBMISSION_DIR}"
mkdir -p "${SUBMISSION_DIR}/figures"
mkdir -p "${SUBMISSION_DIR}/supporting_information"
mkdir -p "${TEMP_DIR}"

echo "===== 开始准备提交包 ====="
echo "源目录: ${PAPER_DIR}"
echo "提交包目录: ${SUBMISSION_DIR}"

# 确保PDF文件已生成
if [ ! -f "${PDF_DIR}/manuscript.pdf" ]; then
  echo "主文档PDF未找到，先运行generate_pdfs.sh生成PDF文件"
  bash "${PAPER_DIR}/generate_pdfs.sh"
fi

# 复制PDF文件到提交目录
echo "复制主要PDF文件..."
cp "${PDF_DIR}/manuscript.pdf" "${SUBMISSION_DIR}/"
cp "${PDF_DIR}/supplementary_materials.pdf" "${SUBMISSION_DIR}/supporting_information/"
cp "${PDF_DIR}/cover_letter.pdf" "${SUBMISSION_DIR}/"
cp "${PDF_DIR}/highlights.pdf" "${SUBMISSION_DIR}/"

# 处理图形文件
echo "处理图形文件..."
if [ -d "${PAPER_DIR}/figures/source" ]; then
  if [ "$(ls -A "${PAPER_DIR}/figures/source")" ]; then
    # 复制和转换图形文件
    for file in "${PAPER_DIR}/figures/source"/*; do
      if [ -f "$file" ]; then
        filename=$(basename "$file")
        extension="${filename##*.}"
        name="${filename%.*}"
        
        # 复制原始文件
        cp "$file" "${SUBMISSION_DIR}/figures/"
        
        # 如果是SVG格式，转换为PDF和PNG
        if [ "$extension" = "svg" ]; then
          echo "转换 ${filename} 到 PDF 和 PNG..."
          
          # 检查inkscape是否可用
          if command -v inkscape &> /dev/null; then
            inkscape -d 300 "$file" -o "${SUBMISSION_DIR}/figures/${name}.png"
            inkscape "$file" -o "${SUBMISSION_DIR}/figures/${name}.pdf"
          else
            echo "警告: inkscape未安装，无法转换SVG文件"
          fi
        fi
      fi
    done
  else
    echo "警告: 图形源目录为空"
  fi
else
  echo "警告: 图形源目录不存在"
fi

# 准备LaTeX提交文件
echo "准备LaTeX提交文件..."

# 创建提交包清单
echo "创建提交包清单..."
cat > "${SUBMISSION_DIR}/README.txt" << EOF
CHEM-JCTC-060 提交包
===================

Entropic Collapse Model of Molecular Stability: A Self-Referential Thermodynamic Framework

提交给: Journal of Chemical Theory and Computation (JCTC)
作者: Loning Ma, Solivian
准备日期: $(date "+%Y-%m-%d")

内容列表:
---------
1. manuscript.pdf - 主论文
2. supporting_information/supplementary_materials.pdf - 补充材料
3. cover_letter.pdf - 投稿信
4. highlights.pdf - 研究亮点
5. figures/ - 图表文件目录
6. supporting_information/ - 补充材料目录

提交说明:
---------
按照JCTC期刊要求，在ACS Paragon Plus系统中提交，将以上文件上传至相应字段。
图表必须单独上传，补充材料作为单独的PDF上传。

联系信息:
---------
如有问题，请联系:
Loning Ma
Email: loning@example.com
EOF

# 创建ZIP归档
echo "创建ZIP归档..."
ARCHIVE_NAME="CHEM-JCTC-060_submission_package.zip"
(cd "${SUBMISSION_DIR}" && zip -r "${ARCHIVE_NAME}" *)

echo "===== 提交包准备完成 ====="
echo "提交包位置: ${SUBMISSION_DIR}/${ARCHIVE_NAME}"
echo "请按照README.txt中的说明进行提交"

# 返回成功状态
exit 0 