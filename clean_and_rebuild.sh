#!/bin/bash
# 清理所有文件中的Version信息并重新生成PDF

# 设置工作目录
WORK_DIR="$(pwd)"
TEMP_DIR="${WORK_DIR}/temp"

# 创建临时目录
mkdir -p "${TEMP_DIR}"

echo "===== 清理所有文件中的Version信息 ====="

# 1. 清理所有.md文件中的Version行
find "${WORK_DIR}" -name "*.md" -type f | while read -r file; do
  echo "处理文件: ${file}"
  # 创建临时文件
  temp_file="${TEMP_DIR}/$(basename "${file}")"
  # 替换Version行
  sed -e 's/Version: 宇宙本论v.*/Version: 1.0/g' \
      -e 's/Version: 宇宙本论.*/Version: 1.0/g' \
      -e 's/Version:.*/Version: 1.0/g' \
      -e 's/version: ".*"/version: "1.0"/g' \
      "${file}" > "${temp_file}"
  # 更新原始文件
  cp "${temp_file}" "${file}"
done

# 2. 特别处理manuscript.md的front matter
if [ -f "${WORK_DIR}/manuscript.md" ]; then
  echo "特别处理manuscript.md的front matter"
  temp_file="${TEMP_DIR}/manuscript.md"
  sed -e 's/version: ".*"/version: "1.0"/g' "${WORK_DIR}/manuscript.md" > "${temp_file}"
  cp "${temp_file}" "${WORK_DIR}/manuscript.md"
fi

# 3. 确保references.md有正确的版本信息
if [ -f "${WORK_DIR}/references.md" ]; then
  echo "确保references.md有正确的版本信息"
  # 检查最后一行是否包含Version信息
  if grep -q "Version: " "${WORK_DIR}/references.md"; then
    echo "正在更新references.md的Version信息"
    temp_file="${TEMP_DIR}/references.md"
    sed -e 's/Version:.*/Version: 1.0\nLast updated: 2025-06-01/g' "${WORK_DIR}/references.md" > "${temp_file}"
    cp "${temp_file}" "${WORK_DIR}/references.md"
  else
    # 如果没有Version信息，添加到文件末尾
    echo -e "\nVersion: 1.0\nLast updated: 2025-06-01" >> "${WORK_DIR}/references.md"
  fi
fi

echo "===== 清理完成 ====="

# 运行generate_pdfs.sh生成新的PDF
echo "===== 运行generate_pdfs.sh生成新的PDF ====="
bash "${WORK_DIR}/generate_pdfs.sh"

# 检查结果
echo "===== 检查生成的PDF文件 ====="
find "${WORK_DIR}/build/pdf" -name "*.pdf" | sort

# 创建额外的文档组合
echo "===== 创建额外文档组合 ====="
ADD_DOC_DIR="${WORK_DIR}/submission_additional_documents"
OUTPUT_DIR="${WORK_DIR}/build/pdf"

if [ -d "${ADD_DOC_DIR}" ]; then
  echo "合并所有额外文档到一个PDF"
  pandoc "${ADD_DOC_DIR}"/author_info.md \
         "${ADD_DOC_DIR}"/keywords.md \
         "${ADD_DOC_DIR}"/funding_statement.md \
         "${ADD_DOC_DIR}"/ethics_statement.md \
         "${ADD_DOC_DIR}"/conflict_of_interest.md \
         "${ADD_DOC_DIR}"/media_summary.md \
         "${ADD_DOC_DIR}"/reviewer_suggestions.md \
         "${ADD_DOC_DIR}"/toc_graphic_description.md \
         -o "${OUTPUT_DIR}/additional_documents/combined_additional_docs.pdf" \
         --pdf-engine=xelatex \
         --variable fontsize=11pt \
         --variable geometry:margin=1in \
         --variable colorlinks=true \
         --standalone
  
  echo "创建最终提交包"
  gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite \
     -sOutputFile="${OUTPUT_DIR}/final_submission_package.pdf" \
     "${OUTPUT_DIR}/manuscript.pdf" \
     "${OUTPUT_DIR}/supplementary_materials.pdf" \
     "${OUTPUT_DIR}/additional_documents/combined_additional_docs.pdf" \
     "${OUTPUT_DIR}/cover_letter.pdf"
fi

echo "===== 所有工作完成 ====="
echo "生成的PDF文件已保存在: ${OUTPUT_DIR}"
echo "最终提交包: ${OUTPUT_DIR}/final_submission_package.pdf" 