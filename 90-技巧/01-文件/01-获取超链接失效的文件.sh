#!/usr/bin/env bash

# ⏹查找指定目录下失效的超链接
find ~/work -type l | while read -r link; do 
    if [ ! -e "$link" ]; then
        echo "失效的链接为: $link"
    fi
done

# --------------------------------------------------
# readlink -f
#   获取文件的绝对路径
# -e
#   判断路径是否存在
# --------------------------------------------------
[ -e "$(readlink -f get_info.sh)" ] && echo "链接所对应的文件存在"
[ -e "$(readlink -f get_info.sh)" ] || echo "链接所对应的文件不存在..."