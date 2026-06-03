<#
.SYNOPSIS
ServiceNow Agent Client Collector (ACC) - Windows 一键静默安装脚本
.DESCRIPTION
利用 MSI 的命令行参数，直接在安装时注入 MID Server URL 和 API Key，彻底避免 YAML 格式错误。
#>

# 🛑 核心配置区 (请核对你的真实信息)
$MidUrl = "wss://10.0.0.4:8043/ws/events"
$ApiKey = "wNykxwXdCeZTG88C8b3DHXDVEfXynjZ3"
$MsiFileName = "agent-client-collector.msi"

# 获取当前脚本所在绝对路径
$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$MsiFullPath = Join-Path $ScriptPath $MsiFileName

Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host "  🚀 Starting ServiceNow ACC Windows Silent Install..." -ForegroundColor Cyan
Write-Host "=======================================================" -ForegroundColor Cyan

# 1. 检查 MSI 文件是否存在
if (-Not (Test-Path $MsiFullPath)) {
    Write-Host "❌ 错误: 找不到安装包 $MsiFullPath" -ForegroundColor Red
    Write-Host "请确保 .msi 文件与此脚本在同一目录下！" -ForegroundColor Yellow
    Exit
}

# 2. 组装静默安装命令 (/i 安装, /qn 静默无UI, /norestart 不重启)
# 将配置参数直接传递给 MSI 引擎，这是 Windows 安装的最优解！
$InstallArgs = "/i `"$MsiFullPath`" /qn /norestart ACC_MID=`"$MidUrl`" ACC_API_KEY=`"$ApiKey`""

Write-Host ">>> [1/3] 📦 Installing ACC via MSI (Please wait)..." -ForegroundColor Yellow

# 3. 运行安装程序并等待完成
$Process = Start-Process -FilePath "msiexec.exe" -ArgumentList $InstallArgs -Wait -NoNewWindow -PassThru

if ($Process.ExitCode -eq 0) {
    Write-Host ">>> [2/3] ✅ MSI Installation completed successfully!" -ForegroundColor Green
} else {
    Write-Host "❌ 安装失败，MSI 退出代码: $($Process.ExitCode)" -ForegroundColor Red
    Exit
}

# 4. 检查服务是否启动
Write-Host ">>> [3/3] ⚡ Verifying ACC Service Status..." -ForegroundColor Yellow
Start-Sleep -Seconds 3 # 给服务一点启动时间

$AccService = Get-Service -Name "acc" -ErrorAction SilentlyContinue
if ($AccService -and $AccService.Status -eq 'Running') {
    Write-Host "=======================================================" -ForegroundColor Cyan
    Write-Host "  🎉 Success! The ACC service is RUNNING." -ForegroundColor Green
    Write-Host "  Printing the latest logs... " -ForegroundColor Cyan
    Write-Host "=======================================================" -ForegroundColor Cyan
    
    # 5. 打印真心话日志 (Windows 的日志默认藏在隐藏文件夹 ProgramData 里)
    $LogPath = "C:\ProgramData\ServiceNow\agent-client-collector\log\acc.log"
    if (Test-Path $LogPath) {
        Get-Content $LogPath -Tail 15 | ForEach-Object { Write-Host $_ -ForegroundColor Gray }
    } else {
        Write-Host "日志文件暂未生成，请稍后再看。" -ForegroundColor Yellow
    }
} else {
    Write-Host "❌ 警告: 安装已完成，但 acc 服务未能正常启动，请检查 Windows 服务管理器 (services.msc)。" -ForegroundColor Red
}