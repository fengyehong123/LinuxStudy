#!/usr/bin/env bash

# 判断keytool命令是否被安装
if ! command -v keytool >/dev/null 2>&1; then
    echo "【keytool】命令并没有被安装, 请确认!"
    exit 1
fi

# 判断openssl命令是否被安装
if ! command -v openssl >/dev/null 2>&1; then
    echo "【openssl】命令并没有被安装, 请确认!"
    exit 1
fi

# 获取当前脚本的绝对路径
SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
# 根据脚本的绝对路径获取脚本所在目录的绝对路径
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

# 私钥别名
ALIAS='alias'
# 密码
PASSWD='nosecret'
# 不带后缀的文件名
FILE_NAME='test_mpl_ws_api'
# pem公钥所对应的key名称
PEM_PUBLIC_KEY='PEM_PUBLIC_KEY_PATH'
# 组织信息
DNAME_INFO='CN=KDDI, OU=IT, O=MyCompany, L=Tokyo, ST=Tokyo, C=JP'

# 创建一个关联数组, 关联数组中的key和value都可以使用变量
declare -A filePathMap=(
    # keystore文件的绝对路径
    [KEYSTORE_FILE_PATH]="$SCRIPT_DIR/${FILE_NAME}.keystore"
    # cer公钥文件的所在路径
    [CER_PUBLIC_KEY_PATH]="$SCRIPT_DIR/${FILE_NAME}.cer"
    # pem公钥文件的所在路径
    ["$PEM_PUBLIC_KEY"]="$SCRIPT_DIR/${FILE_NAME}.pem"
)

# 进入当前脚本所在的目录
pushd "$SCRIPT_DIR" >/dev/null || exit 1

# 生成一个keystore文件
keytool -genkeypair \
-alias "$ALIAS" \
-keyalg RSA \
-sigalg SHA384withRSA \
-keysize 2048 \
-validity 365 \
-keystore "${filePathMap['KEYSTORE_FILE_PATH']}" \
-dname "$DNAME_INFO" \
-storepass "$PASSWD" \
-keypass "$PASSWD"

# 根据keystore文件中的私钥生成cer格式的公钥
keytool -exportcert \
-alias "$ALIAS" \
-keystore "${filePathMap['KEYSTORE_FILE_PATH']}" \
-storepass "$PASSWD" \
-file "${filePathMap['CER_PUBLIC_KEY_PATH']}"

# 通过openssl命令将der格式的公钥转换为pem格式的公钥
openssl x509 \
-inform der \
-in "${filePathMap['CER_PUBLIC_KEY_PATH']}" \
-outform pem \
-out "${filePathMap["$PEM_PUBLIC_KEY"]}"

# 定义一个删除文件的函数
function cleanup_files() {

    # ______________________________________________________________________________________
    # 🔴-n 表示 nameref 引用
    #   1. Bash 没法直接传关联数组，但你可以把数组名传进去，用 declare -n（Bash 4.3+）引用
    #      Bash 4.3之前的旧版本的Bash并不支持。
    #   2. 函数内部用 local -n pathMap=$1，引用只是局部的别名，
    #      原数组本身在外部仍然存在，不会意外覆盖或污染全局变量。
    #   3. 函数结束后，局部 pathMap 作用域消失，不影响其他变量。
    # ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
    local -n pathMap=$1

    # 遍历引入的map
    for pathKey in "${!pathMap[@]}"; do
        # local的局部变量只能在函数内部使用
        local file_path="${pathMap[$pathKey]}"
        # 如果文件存在的话, 就删除
        [[ -f "$file_path" ]] && rm -- "$file_path"
    done
}

# 删除生成的文件
sleep 5
# 调用自定义的函数, 传入关联数组, 删除文件
cleanup_files filePathMap

# 返回到原目录
popd >/dev/null

read -p "→ 脚本执行结束, 按任意键结束 . . . " -n1 -s