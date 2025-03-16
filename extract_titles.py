import os
import re
from pathlib import Path

# 获取文件列表
with open('list.txt', 'r', encoding='utf-8') as f:
    file_list = [line.strip() for line in f.readlines() if line.strip()]

# 提取每个文件的第一个标题
titles = []
for file_path in file_list:
    if not file_path.startswith('./'):
        continue
        
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
            # 查找第一个标题 (# 开头的行)
            title_match = re.search(r'^#\s+(.+)$', content, re.MULTILINE)
            if title_match:
                title = title_match.group(1)
                titles.append(f"{file_path}: {title}")
            else:
                titles.append(f"{file_path}: [无标题]")
    except Exception as e:
        titles.append(f"{file_path}: [读取错误] {str(e)}")

# 将结果写入文件
with open('titles_output.md', 'w', encoding='utf-8') as f:
    f.write("# 文档标题列表\n\n")
    for title in titles:
        f.write(f"- {title}\n")

print(f"成功提取 {len(titles)} 个标题并保存到 titles_output.md") 