#!/usr/bin/env bash

# ---------------------------------------------
# 🔴当脚本退出时，删除创建的临时文件
# 使用 trap 命令来监视脚本的退出信号 EXIT
# ---------------------------------------------
trap 'rm -f "$TMPFILE"' EXIT

# 🔴使用 -t 来指定创建的临时文件的名称模板
#   X字符，表示随机字符，建议至少使用六个X。
TMPFILE=$(mktemp -t mytemp.XXXXXXXXXXXXXXXXXXXXXX) || exit 1
echo "创建的临时文件的路径 $TMPFILE"