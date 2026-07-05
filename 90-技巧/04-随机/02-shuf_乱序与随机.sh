#!/usr/bin/env bash

# 从文件中随机抽取一行
shuf -n 1 input.txt

# 打乱文件内容
cat input.txt | shuf

# 打乱顺序
seq 1 10 | shuf

# 打乱顺序并转为一行
seq 1 10 | shuf | xargs

# 把文件打乱行顺序后按列显示（与 paste 合用）
shuf input.txt | paste - - -

# 随机生成一个 12 位密码（字母 + 数字）
echo {A..Z} {a..z} {0..9} | tr ' ' '\n' | shuf | head -n 12 | tr -d '\n'; echo

# 每次运行脚本随机展示提示语 / 祝福语
shuf -n 1 <<EOF
祝你开心每一天!
工作顺利，万事如意!
代码无Bug!
EOF