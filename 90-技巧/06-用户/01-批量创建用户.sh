#!/usr/bin/env bash

# --------------------------------------------------------------------------------
# ⏹创建用户，并设置密码
# useradd 用户名
# passwd 用户名
#   会提示用户手动输入密码
#
# ⏹跳过提示，直接给用户设置密码
# echo 用户密码 | passwd --stdin 用户名
#
# ⏹设置随机密码
# echo $RANDOM | md5sum | cut -c 1-8
#   先通过 $RANDOM 变量产生随机数之后，再通过md5校验让密码变复杂
#   然后再通过 cut 命令获取前8位数字
# --------------------------------------------------------------------------------

# -------------------------
# 使用root用户执行
# bash ./01-批量创建用户.sh
# -------------------------

# 🔴随机密码方式1
echo "产生的随机密码为: $(echo $RANDOM | md5sum | cut -c 1-8)"
# 🔴随机密码方式2
echo "产生的随机密码为: $(openssl rand -base64 8)"

USER_FILE_PATH=./user_info.txt
for USER in user{1..3}; do
    if ! id "$USER" &>/dev/null; then
        
        # 创建用户
        useradd "$USER"

        # 生成随机密码，设置给生成的用户
        PASS=$(echo $RANDOM | md5sum | cut -c 1-8)
        echo "$USER:$PASS" | chpasswd

        # 将生成的用户和密码相关的信息输出到文件中
        echo "$USER $PASS" >> "$USER_FILE_PATH"
        echo "$USER 用户创建成功!"
    else 
        echo "$USER 用户已经存在..."
    fi
done

