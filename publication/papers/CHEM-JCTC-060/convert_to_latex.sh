#!/bin/bash
# 为CHEM-JCTC-060论文转换Markdown为LaTeX格式

# 确保脚本在任何错误时停止
set -e

# 目录定义
PAPER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LATEX_DIR="${PAPER_DIR}/build/latex"
TEMP_DIR="${PAPER_DIR}/temp"
FIGURES_DIR="${PAPER_DIR}/figures"
TEMPLATE_DIR="${PAPER_DIR}/submission_package/latex_final"

# 创建必要的目录
mkdir -p "${LATEX_DIR}"
mkdir -p "${LATEX_DIR}/figures"
mkdir -p "${TEMP_DIR}"

echo "===== 开始LaTeX转换 ====="
echo "源目录: ${PAPER_DIR}"
echo "LaTeX输出目录: ${LATEX_DIR}"

# 下载ACS LaTeX模板（如果尚未存在）
echo "检查ACS LaTeX模板..."
TEMPLATE_ZIP="${TEMP_DIR}/achemso.zip"
TEMPLATE_URL="https://pubs.acs.org/pb-assets/files/achemso.zip"

if [ ! -f "${TEMPLATE_DIR}/achemso.cls" ]; then
  echo "下载ACS模板..."
  if command -v curl &> /dev/null; then
    curl -L "${TEMPLATE_URL}" -o "${TEMPLATE_ZIP}"
  elif command -v wget &> /dev/null; then
    wget "${TEMPLATE_URL}" -O "${TEMPLATE_ZIP}"
  else
    echo "错误: 需要curl或wget下载模板"
    exit 1
  fi
  
  mkdir -p "${TEMPLATE_DIR}"
  unzip -q "${TEMPLATE_ZIP}" -d "${TEMPLATE_DIR}"
  echo "模板下载并解压到 ${TEMPLATE_DIR}"
fi

# 确保LaTeX目录中有模板文件
cp -r "${TEMPLATE_DIR}"/* "${LATEX_DIR}/"

# 处理图形文件
echo "处理图形文件..."
if [ -d "${FIGURES_DIR}/source" ]; then
  for file in "${FIGURES_DIR}/source"/*; do
    if [ -f "$file" ]; then
      filename=$(basename "$file")
      extension="${filename##*.}"
      name="${filename%.*}"
      
      # 如果是SVG格式，转换为PDF
      if [ "$extension" = "svg" ]; then
        echo "转换 ${filename} 到 PDF..."
        
        # 检查inkscape是否可用
        if command -v inkscape &> /dev/null; then
          inkscape "$file" -o "${LATEX_DIR}/figures/${name}.pdf"
        else
          echo "警告: inkscape未安装，无法转换SVG文件"
          # 复制原文件作为备份
          cp "$file" "${LATEX_DIR}/figures/"
        fi
      else
        # 复制其他格式文件
        cp "$file" "${LATEX_DIR}/figures/"
      fi
    fi
  done
else
  echo "警告: 图形源目录不存在"
fi

# 创建参考文献BibTeX文件
echo "创建参考文献BibTeX文件..."
BIBTEX_FILE="${LATEX_DIR}/references.bib"

# 从references.md提取引用并转换为BibTeX格式
# 这个简单实现可能需要根据实际references.md格式调整
awk '/^[0-9]+\./ {
  title = ""; authors = ""; journal = ""; year = ""; volume = ""; pages = ""; publisher = "";
  line = $0;
  gsub(/^[0-9]+\. /, "", line);
  
  # 提取作者
  match(line, /^(.*?)\(([0-9]{4})\)\./, arr);
  if (arr[1] != "") {
    authors = arr[1];
    year = arr[2];
    sub(/\.$/, "", authors);
  }
  
  # 提取标题和期刊
  match(line, /\([0-9]{4}\)\. (.*?)\. (.*?)/, arr);
  if (arr[1] != "") {
    title = arr[1];
    journal = arr[2];
  }
  
  # 提取卷号和页码
  match(journal, /(.*), ([0-9]+)\(([0-9]+)\), ([0-9]+)\-([0-9]+)\.?$/, arr);
  if (arr[1] != "") {
    journal = arr[1];
    volume = arr[2];
    number = arr[3];
    startpage = arr[4];
    endpage = arr[5];
    pages = startpage "-" endpage;
  }
  
  # 提取出版商
  match(line, /\. ([^\.]+)\.?$/, arr);
  if (arr[1] != "") {
    publisher = arr[1];
  }
  
  # 生成key (使用第一作者姓氏和年份)
  match(authors, /([^,]+)/, arr);
  firstauthor = arr[1];
  gsub(/\s+/, "", firstauthor);
  key = tolower(firstauthor) year;
  
  print "@article{" key ",";
  print "  author = {" authors "},";
  print "  title = {" title "},";
  print "  journal = {" journal "},";
  print "  year = {" year "},";
  if (volume != "") print "  volume = {" volume "},";
  if (pages != "") print "  pages = {" pages "},";
  if (publisher != "") print "  publisher = {" publisher "},";
  print "}";
  print "";
}' "${PAPER_DIR}/references.md" > "${BIBTEX_FILE}"

# 处理主文档
echo "转换主文档为LaTeX..."
MAIN_MD="${PAPER_DIR}/manuscript.md"
MAIN_TEX="${LATEX_DIR}/manuscript.tex"

# 提取元数据
TITLE=$(awk '/^title:/ {gsub(/^title: *"|"$/, ""); print}' "${MAIN_MD}")
JOURNAL=$(awk '/^journal:/ {gsub(/^journal: *"|"$/, ""); print}' "${MAIN_MD}")

# 创建主LaTeX文件
cat > "${MAIN_TEX}" << EOF
\documentclass[journal=jctcce,manuscript=article]{achemso}

\title{${TITLE}}

\author{Loning Ma}
\affiliation{ΨEcho Research Institute}
\email{loning@example.com}

\author{Solivian}
\affiliation{ΨEcho Research Institute}
\email{solivian@echo-institute.org}

\keywords{Molecular Stability, Entropic Collapse, Self-Referential Thermodynamics, Information Theory, Quantum-Classical Bridge}

\begin{document}

\begin{abstract}
EOF

# 提取摘要并添加到LaTeX文件
sed -n '/^## Abstract/,/^##/p' "${MAIN_MD}" | grep -v "^##" >> "${MAIN_TEX}"

# 添加主文档结构
cat >> "${MAIN_TEX}" << EOF
\end{abstract}

\maketitle

EOF

# 处理正文内容（这是简化版本，实际需要更复杂的处理）
# 提取从Introduction到最后的内容
sed -n '/^## 1\. Introduction/,$p' "${MAIN_MD}" | \
  # 替换Markdown标题为LaTeX标题
  sed 's/^## \([0-9]\+\)\. \(.*\)/\\section{\2}/g' | \
  sed 's/^### \([0-9]\+\)\.[0-9]\+ \(.*\)/\\subsection{\2}/g' | \
  # 替换公式
  sed 's/\$\$\(.*\)\$\$/\\begin{equation}\1\\end{equation}/g' | \
  sed 's/\$\(.*\)\$/\\(\1\\)/g' | \
  # 替换表格（简化处理）
  sed 's/^|/\\begin{tabular}{|c|c|c|c|}\n\\hline\n/g' | \
  sed 's/|$/\\\\\n\\hline\n\\end{tabular}/g' | \
  sed 's/|/\&/g' >> "${MAIN_TEX}"

# 添加参考文献
cat >> "${MAIN_TEX}" << EOF

\\bibliography{references}

\\end{document}
EOF

# 创建补充材料LaTeX文件
echo "转换补充材料为LaTeX..."
SUPP_TEX="${LATEX_DIR}/supporting_information.tex"

cat > "${SUPP_TEX}" << EOF
\documentclass[journal=jctcce,manuscript=suppinfo]{achemso}

\title{Supporting Information: ${TITLE}}

\author{Loning Ma}
\affiliation{ΨEcho Research Institute}
\email{loning@example.com}

\author{Solivian}
\affiliation{ΨEcho Research Institute}

\begin{document}

\maketitle

EOF

# 合并数学推导和计算方法
for supp_file in "${PAPER_DIR}/supplementary"/*.md; do
  filename=$(basename "${supp_file}" .md)
  echo "处理补充材料: ${filename}"
  
  # 提取标题
  SUPP_TITLE=$(head -n 1 "${supp_file}" | sed 's/^# //')
  
  # 添加章节标题
  echo "\\section{${SUPP_TITLE}}" >> "${SUPP_TEX}"
  
  # 处理内容（简化版，实际需要更复杂的处理）
  tail -n +3 "${supp_file}" | \
    # 替换Markdown标题为LaTeX标题
    sed 's/^### \(.*\)/\\subsection{\1}/g' | \
    sed 's/^#### \([0-9]\+\)\.[0-9]\+ \(.*\)/\\subsubsection{\2}/g' | \
    # 替换公式
    sed 's/\$\$\(.*\)\$\$/\\begin{equation}\1\\end{equation}/g' | \
    sed 's/\$\(.*\)\$/\\(\1\\)/g' | \
    # 替换代码块（简化处理）
    sed 's/```python/\\begin{verbatim}/g' | \
    sed 's/```/\\end{verbatim}/g' >> "${SUPP_TEX}"
done

# 结束补充材料文件
echo -e "\n\\end{document}" >> "${SUPP_TEX}"

echo "===== LaTeX转换完成 ====="
echo "LaTeX文件已保存至: ${LATEX_DIR}"
echo "主文件: ${MAIN_TEX}"
echo "补充材料: ${SUPP_TEX}"

# 尝试编译LaTeX文件（如果安装了pdflatex和bibtex）
if command -v pdflatex &> /dev/null && command -v bibtex &> /dev/null; then
  echo "开始编译LaTeX文件..."
  
  # 保存当前目录
  CURRENT_DIR=$(pwd)
  
  # 切换到LaTeX目录
  cd "${LATEX_DIR}"
  
  # 编译主文档
  echo "编译主文档..."
  pdflatex -interaction=nonstopmode manuscript.tex
  bibtex manuscript
  pdflatex -interaction=nonstopmode manuscript.tex
  pdflatex -interaction=nonstopmode manuscript.tex
  
  # 编译补充材料
  echo "编译补充材料..."
  pdflatex -interaction=nonstopmode supporting_information.tex
  pdflatex -interaction=nonstopmode supporting_information.tex
  
  # 回到原目录
  cd "${CURRENT_DIR}"
  
  # 复制生成的PDF到PDF目录
  mkdir -p "${PAPER_DIR}/build/pdf/latex"
  cp "${LATEX_DIR}/manuscript.pdf" "${PAPER_DIR}/build/pdf/latex/"
  cp "${LATEX_DIR}/supporting_information.pdf" "${PAPER_DIR}/build/pdf/latex/"
  
  echo "LaTeX编译完成"
  echo "PDF文件已保存至: ${PAPER_DIR}/build/pdf/latex/"
else
  echo "警告: 未安装pdflatex和bibtex，跳过编译步骤"
  echo "要编译LaTeX文件，请安装TeX Live或MiKTeX，然后手动运行编译命令"
fi

# 返回成功状态
exit 0 