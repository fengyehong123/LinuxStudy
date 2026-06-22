@echo off
:: 切换到当前.bat脚本所在的目录
:: 注意
:: cd /d 的意思并不是切换到d盘, 而是切换到文件夹的意思
cd /d "%~dp0"

set TTPMACRO="C:\Program Files\teraterm5\ttpmacro.exe"
set MARCO="06-ttl脚本.ttl"
set HOSTNAME=%USERNAME%

%TTPMACRO% %MARCO% %HOSTNAME%

exit