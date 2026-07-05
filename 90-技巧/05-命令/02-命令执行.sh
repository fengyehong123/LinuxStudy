#!/usr/bin/env bash

# ⏹方式1
# 优点：简单直观，能完整打印出要执行的命令。
# 缺点：需要 eval，注意不要传入不可信输入（安全隐患）。
function run_cmd1() {
    # $*
    #   将所有参数都当成一整个字符串
    # "$*"
    #   把所有参数合并成 一个字符串，参数之间用 IFS（默认空格）分隔。
    local cmd="$*"
    echo -e "\n执行的命令如下: \n    ${cmd}"
    echo -e "\n结果如下:"
    eval "$cmd"
}

# 用法
run_cmd1 ls -l /etc
run_cmd1 "echo "$RANDOM" | md5sum | cut -c 1-8"

# 如果命令太长的话, 可以换行, 如果参数中有空格需要通过 " 进行包裹的话, 需要通过 \ 对 " 进行转义
cmd1="echo \
\"$PATH\" | \
xargs -d ':' -L 1 | \
head"
run_cmd1 "$cmd1"
# ---------------------------------------------------
echo '+ ------------------------------------------- +'

# ⏹方式2
# 如果长命令里有 管道/重定向/子命令的话，这种方式也可以
function run_cmd2() {
    local cmd="$*"
    echo -e "\n执行的命令如下: \n    ${cmd}"
    echo -e "\n结果如下:"
    bash -c "$cmd"
}

run_cmd2 ls -l /etc
run_cmd2 "echo "$RANDOM" | md5sum | cut -c 1-8"

cmd2="echo \
\"$PATH\" | \
xargs -d ':' -L 1 | \
head"
run_cmd2 "$cmd2"