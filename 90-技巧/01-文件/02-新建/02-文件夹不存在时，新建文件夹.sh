#!/usr/bin/env bash

# 获取当天日期
today=$(date '+%Y%m%d')
# 待创建的工作目录
work_folder=~/work/"$today"_db

# 判断文件夹是否存在，若不存在则新创建
[ -d "$work_folder" ] || (mkdir "$work_folder" && ls -ld "$work_folder")