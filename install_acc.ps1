<#
.SYNOPSIS
ServiceNow Agent Client Collector (ACC) - Windows Silent Install
#>

$MidUrl = "wss://10.0.0.4:8043/ws/events"
$ApiKey = "wNykxwXdCeZTG88C8b3DHXDVEfXynjZ3"
$MsiFileName = "agent-client-collector.msi"

$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$MsiFullPath = Join-Path $ScriptPath $MsiFileName

Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host "  Starting ServiceNow ACC Windows Silent Install..." -ForegroundColor Cyan
Write-Host "=======================================================" -ForegroundColor Cyan

if (-Not (Test-Path $MsiFullPath)) {
    Write-Host "[Error] Cannot find $MsiFullPath" -ForegroundColor Red
    Exit
}

$InstallArgs = "/i `"$MsiFullPath`" /qn /norestart ACC_MID=`"$MidUrl`" ACC_API_KEY=`"$ApiKey`""

Write-Host ">>> [1/3] Installing ACC via MSI (Please wait)..." -ForegroundColor Yellow

$Process = Start-Process -FilePath "msiexec.exe" -ArgumentList $InstallArgs -Wait -NoNewWindow -PassThru

if ($Process.ExitCode -eq 0) {
    Write-Host ">>> [2/3] MSI Installation completed successfully!" -ForegroundColor Green
} else {
    Write-Host "[Error] Installation failed, Exit Code: $($Process.ExitCode)" -ForegroundColor Red
    Exit
}

Write-Host ">>> [3/3] Verifying ACC Service Status..." -ForegroundColor Yellow
Start-Sleep -Seconds 3

$AccService = Get-Service -Name "acc" -ErrorAction SilentlyContinue
if ($AccService -and $AccService.Status -eq 'Running') {
    Write-Host "=======================================================" -ForegroundColor Cyan
    Write-Host "  Success! The ACC service is RUNNING." -ForegroundColor Green
    Write-Host "  Printing the latest logs... " -ForegroundColor Cyan
    Write-Host "=======================================================" -ForegroundColor Cyan
    
    $LogPath = "C:\ProgramData\ServiceNow\agent-client-collector\log\acc.log"
    if (Test-Path $LogPath) {
        Get-Content $LogPath -Tail 15 | ForEach-Object { Write-Host $_ -ForegroundColor Gray }
    } else {
        Write-Host "Log file not generated yet." -ForegroundColor Yellow
    }
} else {
    Write-Host "[Warning] Install finished, but 'acc' service is not running." -ForegroundColor Red
}