#!/usr/bin/env bash

# 确认当前主机名
hostname

# 修改主机名
sudo hostnamectl set-hostname 要修改的主机名

# 验证修改的结果
hostnamectl