#!/bin/bash
# PDF生成脚本

# 创建输出目录
mkdir -p build/pdf
mkdir -p build/pdf/additional_documents
mkdir -p figures/pdf

echo "===== 开始生成PDF ====="

# 从SVG生成图表PDF
echo "Converting figures from SVG to PDF..."
cd figures/source
for file in *.svg; do
  filename=$(basename "$file" .svg)
  if [ -f "$file" ]; then
    echo "Converting $file to PDF..."
    # 使用rsvg-convert或inkscape转换SVG到PDF
    # 如果系统中有inkscape
    if command -v inkscape &> /dev/null; then
      inkscape -f "$file" -A "../pdf/${filename}.pdf"
    # 如果系统中有rsvg-convert
    elif command -v rsvg-convert &> /dev/null; then
      rsvg-convert -f pdf -o "../pdf/${filename}.pdf" "$file"
    else
      echo "Warning: Neither inkscape nor rsvg-convert found. Skipping SVG conversion."
    fi
  fi
done
cd ../..

# 转换主要文档到LaTeX和PDF
echo "Converting manuscript.md to LaTeX and PDF..."
mkdir -p temp/latex
pandoc manuscript.md \
  --pdf-engine=xelatex \
  --template=temp/nature_physics.latex \
  -o build/pdf/PHY-NAT-007_manuscript.pdf

# 转换附加文档
echo "Converting supplementary materials..."
for file in supplementary/*.md; do
  if [ -f "$file" ]; then
    filename=$(basename "$file" .md)
    echo "Converting $file to PDF..."
    pandoc "$file" \
      --pdf-engine=xelatex \
      -o "build/pdf/PHY-NAT-007_${filename}.pdf"
  fi
done

# 转换其他重要文档
echo "Converting additional documents..."
pandoc cover_letter.md -o "build/pdf/additional_documents/cover_letter.pdf" --pdf-engine=xelatex
pandoc submission_additional_documents/author_info.md -o "build/pdf/additional_documents/author_info.pdf" --pdf-engine=xelatex

echo "===== PDF生成完成 ====="
echo "所有PDF文件已生成到build/pdf/目录"
ls -la build/pdf/

# 清理临时文件
rm -rf temp/latex/*.aux temp/latex/*.log temp/latex/*.out 