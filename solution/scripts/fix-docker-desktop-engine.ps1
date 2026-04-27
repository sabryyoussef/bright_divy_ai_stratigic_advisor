# Repair stuck Docker Linux engine (HTTP 500 on docker info / _ping).
# Run in PowerShell. If "com.docker.service" fails to start, re-run as Administrator.
#
# Evidence on your machine: com.docker.backend logs show
#   "still waiting for the engine to respond to _ping ... HTTP 500"

param(
    [switch]$SkipWslShutdown
)

$ErrorActionPreference = "Continue"

Write-Host "=== 1) Stop Docker Desktop (avoid docker desktop stop when engine is stuck - it can hang) ===" -ForegroundColor Cyan
Get-Process "Docker Desktop" -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process "com.docker.backend" -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process "Docker Desktop Service" -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 8

Write-Host "=== 2) WSL shutdown (unsticks docker-desktop VM) ===" -ForegroundColor Cyan
if (-not $SkipWslShutdown) {
    wsl --shutdown
    Start-Sleep -Seconds 8
}

Write-Host "=== 3) Start Docker Desktop Windows service ===" -ForegroundColor Cyan
try {
    $svc = Get-Service com.docker.service -ErrorAction Stop
    if ($svc.Status -ne "Running") {
        Start-Service com.docker.service -ErrorAction Stop
    }
    Write-Host "com.docker.service is Running." -ForegroundColor Green
}
catch {
    Write-Host "Could not start com.docker.service: $_" -ForegroundColor Yellow
    Write-Host "Re-run this script in an elevated PowerShell (Run as Administrator)." -ForegroundColor Yellow
}

Write-Host "=== 4) Launch Docker Desktop ===" -ForegroundColor Cyan
$dd = "${env:ProgramFiles}\Docker\Docker\Docker Desktop.exe"
if (Test-Path $dd) {
    Start-Process $dd
}
else {
    Write-Host "Docker Desktop.exe not found at $dd" -ForegroundColor Yellow
}

Write-Host "=== 5) Wait for engine (up to 3 minutes) ===" -ForegroundColor Cyan
$deadline = (Get-Date).AddMinutes(3)
while ((Get-Date) -lt $deadline) {
    $out = & docker info 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Docker engine is healthy." -ForegroundColor Green
        exit 0
    }
    Start-Sleep -Seconds 5
}

Write-Host "Engine still unhealthy. Next steps:" -ForegroundColor Red
Write-Host "  - Docker Desktop -> Troubleshoot -> Restart" -ForegroundColor White
Write-Host "  - Or: Reset to factory defaults (last resort)" -ForegroundColor White
Write-Host "  - Or: use WSL warehouse path: wsl then bash solution/wsl/bootstrap-warehouse.sh" -ForegroundColor White
Write-Host "Logs: $($env:LOCALAPPDATA)\Docker\log\host\com.docker.backend.exe.log" -ForegroundColor Gray
exit 1
