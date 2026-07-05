#!/usr/bin/env bash

# 定义颜色的别名
Green_font_prefix="\033[32m"
Red_font_prefix="\033[31m"
Green_background_prefix="\033[42;37m"
Red_background_prefix="\033[41;37m"
Font_color_suffix="\033[0m"

# 定义提示信息
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"

# ##################################################################
# 	$EUID 是 Linux / Unix shell 里的一个环境变量，表示：
# 		Effective User ID（有效用户 ID）
# 		也就是：当前进程“实际以谁的身份在运行”。
# 
#   当 $EUID 为0, 说明当前正在使用root权限
#
#	常用于：
#		判断是否 root
#		sudo / su 行为理解
#		安全脚本编写
# ##################################################################

# check当前用户是否有root权限
check_root(){
	[[ $EUID != 0 ]] && echo -e "${Error} 当前非ROOT账号(或没有ROOT权限), 无法继续操作, 请更换ROOT账号或使用 ${Green_background_prefix}sudo su${Font_color_suffix} 命令获取临时ROOT权限(执行后可能会提示输入当前账号的密码)。" && exit 1
}

check_root