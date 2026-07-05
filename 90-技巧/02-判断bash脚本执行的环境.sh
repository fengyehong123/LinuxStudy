#!/usr/bin/env bash

function detect_os1() {
    
    # 通过【uname -s 】来判断
    local unameOut="$(uname -s)"

    case "$unameOut" in
        Linux*)
            echo "linux"
            ;;
        MINGW*|MSYS*|CYGWIN*)
            echo "git_bash_Windows"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

function detect_os2() {

    # 通过【uname -o】来判断
    if [[ "$(uname -o 2>/dev/null)" == "Msys" ]]; then
        echo "git_bash_Windows"
    else
        echo "Linux"
    fi
}

function detect_os3() {

    # 通过【OSTYPE】变量来判断
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "Linux"
    elif [[ "$OSTYPE" == "msys"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
        echo "git_bash_Windows"
    else
        echo "unknown_os"
    fi
}

# 调用函数, 获取echo打印的值
os_type1=$(detect_os1)
echo "$os_type1"

os_type2=$(detect_os2)
echo "$os_type2"

os_type3=$(detect_os3)
echo "$os_type3"





