#!/usr/bin/env bash

# 定义一个路径的变量
path="/home/user/docs/file.txt"

# 从路径中获取文件名
echo "${path##*/}"   # file.txt                (相当于 basename)
# 获取除了文件名外的路径部分
echo "${path%/*}"    # /home/user/docs         (相当于 dirname)

# 去掉最前面的 /
echo "${path#*/}"    # home/user/docs/file.txt

# 获取除了文件名后缀之外的路径部分
echo "${path%.txt}"  # /home/user/docs/file
# 获取不含后缀的文件名
echo "${path##*.}"   # txt