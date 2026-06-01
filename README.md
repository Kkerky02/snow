yml
# 1. 指向你的 MID Server 地址 (注意替换 IP/域名 和 端口)
backend:
  - url: "wss://<YOUR_MID_SERVER_IP_OR_FQDN>:<PORT>/ws/events"

# 2. 从 ServiceNow 实例中生成的 ACC 注册密钥
mid_secret: "<YOUR_REGISTRATION_KEY>"

# 3. (可选) 定义 Agent 的名称，如果不填通常默认使用主机名
agent:
  name: "<CUSTOM_AGENT_NAME>"

选项 A：Windows 环境部署 (PowerShell 脚本)
在同一目录下新建一个名为 Install-ACC.ps1 的文件，填入以下代码。右键使用 PowerShell 运行即可（需要管理员权限）：
  # --- Windows ACC 静默安装脚本 ---

# 请将此处替换为你实际下载的 MSI 文件名
$InstallerName = "agent-client-collector-1.0.0.msi" 

$CurrentPath = Get-Location
$MsiPath = Join-Path -Path $CurrentPath -ChildPath $InstallerName
$YmlPath = Join-Path -Path $CurrentPath -ChildPath "acc.yml"
$TargetYmlDir = "$env:ProgramData\ServiceNow\agent-client-collector\config"

Write-Host "1. 正在静默安装 ServiceNow ACC..."
# /i 安装, /qn 无界面静默模式, /norestart 不自动重启
Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$MsiPath`" /qn /norestart" -Wait -NoNewWindow

Write-Host "2. 正在覆盖自定义的 acc.yml 配置文件..."
if (Test-Path $YmlPath) {
    Copy-Item -Path $YmlPath -Destination "$TargetYmlDir\acc.yml" -Force
    Write-Host "配置文件替换成功！"
} else {
    Write-Warning "未在当前目录找到 acc.yml，请检查！"
}

Write-Host "3. 正在重启 ACC 服务以应用新配置..."
Restart-Service -Name "acc" -Force

Write-Host "部署完成！请前往 ServiceNow 实例检查 Agent 是否已上线。"




选项 B：Linux (RedHat/CentOS) 环境部署 (Shell 脚本)
在同一目录下新建一个名为 install_acc.sh 的文件，填入以下代码。给予执行权限 (chmod +x install_acc.sh) 后，使用 sudo 执行：

#!/bin/bash
# --- Linux ACC 静默安装脚本 ---

# 请将此处替换为你实际下载的 rpm 文件名
INSTALLER_FILE="agent-client-collector-1.0.0.rpm"
CUSTOM_YML="acc.yml"
TARGET_YML_PATH="/etc/servicenow/acc/acc.yml"

echo "1. 正在静默安装 ServiceNow ACC..."
sudo rpm -ivh $INSTALLER_FILE

echo "2. 正在覆盖自定义的 acc.yml 配置文件..."
if [ -f "$CUSTOM_YML" ]; then
    sudo cp $CUSTOM_YML $TARGET_YML_PATH
    # 确保 ServiceNow 账号有权限读取该文件
    sudo chown servicenow:servicenow $TARGET_YML_PATH
    sudo chmod 640 $TARGET_YML_PATH
    echo "配置文件替换成功！"
else
    echo "警告: 未在当前目录找到 acc.yml！"
fi

echo "3. 正在启动并设置 ACC 服务开机自启..."
sudo systemctl enable acc
sudo systemctl restart acc

echo "部署完成！请前往 ServiceNow 实例检查 Agent 是否已上线。"
