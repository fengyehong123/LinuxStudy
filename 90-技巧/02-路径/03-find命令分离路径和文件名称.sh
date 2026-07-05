#!/usr/bin/env bash

# %h = 文件所在目录 → 获取当前目录下 .sh 文件所在的文件夹路径
realpath $(find ./ -type f -name "*.sh" -printf "%h\n") | uniq | head
echo -e "\e[1;31m/_/_/_/_/_/_/_/_/_/_/_/_/_/_分割线_/_/_/_/_/_/_/_/_/_/_/_/_/_/\e[0m"

# %f = 文件名      → 获取当前目录下 .sh 文件名称
find ./ -type f -name "*.sh" -printf "%f\n" | head