#!/bin/bash
# 为CHEM-JCTC-060论文生成PDF文件

# 确保脚本在任何错误时停止
set -e

# 目录定义
PAPER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="${PAPER_DIR}/build/pdf"
TEMP_DIR="${PAPER_DIR}/temp"
LATEX_DIR="${PAPER_DIR}/build/latex"
FIGURES_DIR="${PAPER_DIR}/figures"
FIGURES_PDF_DIR="${FIGURES_DIR}/pdf"

# 首先删除现有的所有PDF文件
echo "===== 删除现有的PDF文件 ====="
rm -rf "${OUTPUT_DIR}"/*
rm -rf "${FIGURES_PDF_DIR}"/*

# 创建必要的目录
mkdir -p "${OUTPUT_DIR}"
mkdir -p "${OUTPUT_DIR}/additional_documents"
mkdir -p "${OUTPUT_DIR}/supplementary"
mkdir -p "${TEMP_DIR}"
mkdir -p "${LATEX_DIR}"
mkdir -p "${FIGURES_PDF_DIR}"

echo "===== 开始生成PDF文件 ====="
echo "源目录: ${PAPER_DIR}"
echo "输出目录: ${OUTPUT_DIR}"

# SVG图表转换为PDF
echo "正在将SVG图表转换为PDF..."
svg_conversion_success=false

if command -v inkscape &> /dev/null; then
  for svg_file in "${FIGURES_DIR}/source/"*.svg; do
    if [ -f "$svg_file" ]; then
      filename=$(basename "${svg_file}" .svg)
      echo "转换: ${filename}.svg"
      inkscape --export-filename="${FIGURES_PDF_DIR}/${filename}.pdf" "${svg_file}"
    fi
  done
  svg_conversion_success=true
elif command -v cairosvg &> /dev/null; then
  for svg_file in "${FIGURES_DIR}/source/"*.svg; do
    if [ -f "$svg_file" ]; then
      filename=$(basename "${svg_file}" .svg)
      echo "转换: ${filename}.svg (使用cairosvg)"
      cairosvg "${svg_file}" -o "${FIGURES_PDF_DIR}/${filename}.pdf"
    fi
  done
  svg_conversion_success=true
elif command -v rsvg-convert &> /dev/null; then
  for svg_file in "${FIGURES_DIR}/source/"*.svg; do
    if [ -f "$svg_file" ]; then
      filename=$(basename "${svg_file}" .svg)
      echo "转换: ${filename}.svg (使用rsvg-convert)"
      rsvg-convert -f pdf -o "${FIGURES_PDF_DIR}/${filename}.pdf" "${svg_file}"
    fi
  done
  svg_conversion_success=true
else
  echo "警告: 未找到SVG转PDF工具（Inkscape、cairosvg或rsvg-convert）。"
  echo "图表PDF将无法生成，但继续生成其他PDF文件。"
  echo "请考虑安装以下工具之一以生成图表PDF:"
  echo "  - Inkscape: https://inkscape.org/"
  echo "  - cairosvg: pip install cairosvg"
  echo "  - rsvg-convert: 系统包管理器安装librsvg"
fi

# 处理文件中的宇宙本论版本号
echo "移除宇宙本论版本号引用..."
for md_file in $(find "${PAPER_DIR}" -name "*.md"); do
  if grep -q "\[宇宙本论版本号\]" "${md_file}"; then
    echo "处理文件: ${md_file}"
    # 创建临时文件
    temp_file="${TEMP_DIR}/$(basename "${md_file}")"
    # 替换版本号引用和宇宙本论v前缀
    sed -e 's/\[宇宙本论版本号\]//g' -e 's/宇宙本论v//g' -e 's/version: ""/version: "1.0"/g' "${md_file}" > "${temp_file}"
    # 创建临时文件的备份
    cp "${md_file}" "${md_file}.bak"
    # 更新原始文件
    cp "${temp_file}" "${md_file}"
  fi
done

# 生成主文档PDF
echo "正在生成主文档PDF..."
pandoc "${PAPER_DIR}/manuscript.md" \
  --pdf-engine=xelatex \
  --variable mainfont="Times New Roman" \
  --variable monofont="Courier New" \
  --variable fontsize=11pt \
  --variable geometry:margin=1in \
  --variable links-as-notes=true \
  --variable colorlinks=true \
  --standalone \
  --toc \
  -o "${OUTPUT_DIR}/manuscript.pdf"

# 生成补充材料PDF
echo "正在生成补充材料PDF..."
SUPP_FILES=("mathematical_proofs.md" "computational_methods.md")
for file in "${SUPP_FILES[@]}"; do
  if [ -f "${PAPER_DIR}/supplementary/${file}" ]; then
    filename=$(basename "${file}" .md)
    echo "处理: ${filename}"
    
    pandoc "${PAPER_DIR}/supplementary/${file}" \
      --pdf-engine=xelatex \
      --variable mainfont="Times New Roman" \
      --variable monofont="Courier New" \
      --variable fontsize=11pt \
      --variable geometry:margin=1in \
      --variable links-as-notes=true \
      --variable colorlinks=true \
      --standalone \
      -o "${OUTPUT_DIR}/supplementary/${filename}.pdf"
  fi
done

# 合并所有补充材料为一个文件
echo "合并补充材料为一个文件..."
if [ -n "$(ls -A "${OUTPUT_DIR}/supplementary/" 2>/dev/null)" ]; then
  gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite \
    -sOutputFile="${OUTPUT_DIR}/supplementary_materials.pdf" \
    "${OUTPUT_DIR}/supplementary/"*.pdf
else
  echo "没有找到补充材料PDF，跳过合并步骤"
fi

# 生成提交文件PDF
echo "正在生成提交文件PDF..."
SUBMIT_FILES=("cover_letter.md" "highlights.md" "submission_checklist.md")
for file in "${SUBMIT_FILES[@]}"; do
  if [ -f "${PAPER_DIR}/${file}" ]; then
    filename=$(basename "${file}" .md)
    echo "处理: ${filename}"
    
    pandoc "${PAPER_DIR}/${file}" \
      --pdf-engine=xelatex \
      --variable mainfont="Times New Roman" \
      --variable monofont="Courier New" \
      --variable fontsize=11pt \
      --variable geometry:margin=1in \
      --variable links-as-notes=true \
      --variable colorlinks=true \
      --standalone \
      -o "${OUTPUT_DIR}/${filename}.pdf"
  fi
done

# 生成额外文档PDF
echo "正在生成额外文档PDF..."
ADD_DOC_DIR="${PAPER_DIR}/submission_additional_documents"
for file in "${ADD_DOC_DIR}"/*.md; do
  if [ -f "$file" ]; then
    filename=$(basename "${file}" .md)
    echo "处理: ${filename}"
    
    pandoc "${file}" \
      --pdf-engine=xelatex \
      --variable mainfont="Times New Roman" \
      --variable monofont="Courier New" \
      --variable fontsize=11pt \
      --variable geometry:margin=1in \
      --variable links-as-notes=true \
      --variable colorlinks=true \
      --standalone \
      -o "${OUTPUT_DIR}/additional_documents/${filename}.pdf"
  fi
done

# 创建汇总PDF
echo "创建汇总文档..."
DOCS_TO_COMBINE=("${OUTPUT_DIR}/manuscript.pdf")

# 添加补充材料（如果存在）
if [ -f "${OUTPUT_DIR}/supplementary_materials.pdf" ]; then
  DOCS_TO_COMBINE+=("${OUTPUT_DIR}/supplementary_materials.pdf")
fi

# 添加其他文档
for doc in cover_letter highlights; do
  if [ -f "${OUTPUT_DIR}/${doc}.pdf" ]; then
    DOCS_TO_COMBINE+=("${OUTPUT_DIR}/${doc}.pdf")
  fi
done

# 执行合并
gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite \
  -sOutputFile="${OUTPUT_DIR}/complete_manuscript_package.pdf" \
  "${DOCS_TO_COMBINE[@]}"

echo "===== PDF生成完成 ====="
echo "所有PDF文件已保存至: ${OUTPUT_DIR}"
echo "图表PDF文件已保存至: ${FIGURES_PDF_DIR}"
echo "完整文档包: ${OUTPUT_DIR}/complete_manuscript_package.pdf"

# 删除备份文件 - 自动保留修改后的文件，不需要询问
find "${PAPER_DIR}" -name "*.md.bak" -delete
echo "清理完成，所有修改已保存"

# 返回成功状态
exit 0 