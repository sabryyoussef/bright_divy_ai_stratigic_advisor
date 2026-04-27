# Step 1b: start warehouse and list tables.
# Run:
#   powershell -ExecutionPolicy Bypass -File "d:\bright_info\solution\scripts\verify-step1b.ps1"

$ErrorActionPreference = "Stop"
$SolutionDir = Split-Path $PSScriptRoot -Parent
Set-Location $SolutionDir

if (-not (Test-Path "docker-compose.yml")) {
    throw "docker-compose.yml not found in $SolutionDir"
}

Write-Host "== docker info (engine must be healthy) ==" -ForegroundColor Cyan
docker info 2>&1 | Out-Host
if ($LASTEXITCODE -ne 0) {
    Write-Host "`nDocker engine is not healthy (common: HTTP 500 on _ping)." -ForegroundColor Red
    Write-Host "Repair (PowerShell):" -ForegroundColor Yellow
    Write-Host "  powershell -ExecutionPolicy Bypass -File `"$PSScriptRoot\fix-docker-desktop-engine.ps1`"" -ForegroundColor White
    Write-Host "Re-run as Administrator if com.docker.service fails to start." -ForegroundColor Gray
    Write-Host "`nWorkaround - same warehouse schema on WSL Postgres:" -ForegroundColor Yellow
    Write-Host "  wsl -d Ubuntu" -ForegroundColor White
    Write-Host '  cd /mnt/d/bright_info/solution/wsl && bash bootstrap-warehouse.sh' -ForegroundColor White
    Write-Host "  bash verify-warehouse.sh" -ForegroundColor White
    exit 1
}

Write-Host "`n== docker compose up -d (wait for health) ==" -ForegroundColor Cyan
docker compose up -d --wait

Write-Host "`n== list tables ==" -ForegroundColor Cyan
docker compose exec -T warehouse psql -U warehouse -d warehouse -c '\dt'

Write-Host "`nStep 1b OK: dim_date and fact_transactions should appear above." -ForegroundColor Green
