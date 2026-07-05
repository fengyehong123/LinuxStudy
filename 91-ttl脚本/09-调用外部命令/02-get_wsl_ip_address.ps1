param(
    [string]$WSL_NAME,
    [string]$tmp_wsl_ip_address_full_temp_path
)

# 根据wsl的名称获取wsl的ip地址
$wsl_ip_address = (wsl -d "$WSL_NAME" -e hostname -I).Trim();
[System.IO.File]::WriteAllText(
    "$tmp_wsl_ip_address_full_temp_path",
    "$wsl_ip_address",
    # $false 表示不使用BOM
    (New-Object System.Text.UTF8Encoding($false))
)