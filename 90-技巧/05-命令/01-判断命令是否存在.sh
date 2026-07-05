#!/usr/bin/env bash

# 判断指定的命令是否存在
if ! command -v keytool >/dev/null 2>&1; then
    echo "【keytool】命令并没有被安装, 请确认!"
    exit 1
fi

if ! command -v openssl >/dev/null 2>&1; then
    echo "【openssl】命令并没有被安装, 请确认!"
    exit 1
fi

if ! command -v hello_test >/dev/null 2>&1; then
    echo "【hello_test】命令并没有被安装, 请确认!"
    exit 1
fi