#!/usr/bin/env bash

# 获取当前脚本的绝对路径
SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
# 根据脚本的绝对路径获取脚本所在目录的绝对路径
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

echo "$0"
# 打印脚本所在的文件夹路径
#   $0 代表 当前执行的脚本的路径
#     如果当前调用该脚本用到的是相对路径, 那么 $0 的值就是该相对路径
#   通过 readlink -f 可以将相对路径转换为绝对路径
echo "$(readlink -f $(dirname $0))"
echo "$SCRIPT_DIR"

# 打印脚本所在的绝对路径
echo "$SCRIPT_PATH"