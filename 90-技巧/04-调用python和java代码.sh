#!/usr/bin/env bash

# 判断java命令是否被安装
if ! command -v java >/dev/null 2>&1; then
    echo "【java】命令并没有被安装, 请确认!"
    exit 1
fi

# 判断python命令是否被安装
if ! command -v python >/dev/null 2>&1; then
    echo "【python】命令并没有被安装, 请确认!"
    exit 1
fi

# 获取当前脚本的绝对路径
SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
# 根据脚本的绝对路径获取脚本所在目录的绝对路径
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

# 拼接python代码所在的路径
PYTHON_FILE_PATH="$SCRIPT_DIR/00-source/PythonSource.py"
# 拼接java代码所在的路径
JAVA_FILE_PATH="$SCRIPT_DIR/00-source/JavaSource.java"

# 🔴 ______________________________ 调用Python代码 ______________________________
# 在bash中调用python代码, 获取其返回值和退出码
python_result=$(python "$PYTHON_FILE_PATH")
# 获取退出码必须要在获取返回值之前, 否则echo命令打印了返回值之后, Bash捕获的就不是python的退出码而是echo命令的执行状态了
echo "Python程序的退出码是: $?"
# 获取python的打印值
echo "Python程序的结果是: $python_result"

# 🔴 ______________________________ 调用Java代码 ______________________________
# 进入 Java 文件所在目录
#   $(dirname $JAVA_FILE_PATH) → 获取 Java 文件所在目录
#   pushd <dir>                → 切换到指定目录，同时把当前目录 压入目录栈
#   >/dev/null                 → 屏蔽 pushd 输出
#   || exit 1                  → 如果目录不存在或切换失败，退出脚本
pushd "$(dirname $JAVA_FILE_PATH)" >/dev/null || exit 1

# 编译java代码(指定使用UTF-8编译, 防止windows中默认使用GBK编码)
# 编译之后会在当前目录下生成一个.class文件
javac -encoding UTF-8 "$JAVA_FILE_PATH"
if [ $? -ne 0 ]; then
    echo "编译失败！"
    # popd → 从目录栈弹出上一个目录，并切换回去
    # >/dev/null → 屏蔽输出
    popd >/dev/null
    exit 1
fi

# 从绝对路径中获取java不带后缀的文件名
JAVA_FILE_BASENAME=$(basename "$JAVA_FILE_PATH" '.java')
echo '____________________________________'
echo "$JAVA_FILE_PATH"
echo "$JAVA_FILE_BASENAME"
echo '‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾'

# 执行编译后的java代码
java_result=$(java "$JAVA_FILE_BASENAME")
echo "Java程序的退出码是: $?"
# 获取java的打印值
echo -e "java程序的结果是: $java_result\n"

# 删除生成的.class文件
sleep 2
rm "${JAVA_FILE_BASENAME}.class"

# 返回到原目录
popd >/dev/null

# 退出
read -p "→ 脚本执行结束, 按任意键结束 . . . " -n1 -s
