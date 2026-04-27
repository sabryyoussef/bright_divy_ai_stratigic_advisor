# Start warehouse + analytics (compose.stack.yml), then smoke-test HTTP endpoints.
# Run from repo:
#   powershell -ExecutionPolicy Bypass -File "d:\bright_info\solution\scripts\verify-local-stack.ps1"

$ErrorActionPreference = "Stop"
# .../bright_info/solution/scripts -> .../bright_info/solution
$SolutionDir = Split-Path $PSScriptRoot -Parent
Set-Location $SolutionDir

Write-Host "== docker compose (warehouse + analytics) ==" -ForegroundColor Cyan
docker compose -f docker-compose.yml -f stack/compose.stack.yml up -d --build --wait

# Published host port (see stack/compose.stack.yml); avoids 127.0.0.1:8001 clashes on Windows.
$AnalyticsHostPort = 18001

function Wait-AnalyticsHttp {
    param([int]$TimeoutSec = 45)
    $deadline = (Get-Date).AddSeconds($TimeoutSec)
    while ((Get-Date) -lt $deadline) {
        try {
            $null = Invoke-WebRequest -Uri "http://127.0.0.1:$AnalyticsHostPort/health" -UseBasicParsing -TimeoutSec 5
            return
        } catch {
            Start-Sleep -Seconds 2
        }
    }
    throw "Analytics did not accept HTTP on port $AnalyticsHostPort within ${TimeoutSec}s."
}

Write-Host "`n== analytics /health (host port $AnalyticsHostPort) ==" -ForegroundColor Cyan
Wait-AnalyticsHttp
Invoke-RestMethod "http://127.0.0.1:$AnalyticsHostPort/health" | ConvertTo-Json -Compress

Write-Host "`n== analytics /health/db ==" -ForegroundColor Cyan
Invoke-RestMethod "http://127.0.0.1:$AnalyticsHostPort/health/db" | ConvertTo-Json -Compress

Write-Host "`n== analytics financial bleed ==" -ForegroundColor Cyan
Invoke-RestMethod -Method Post `
    -Uri "http://127.0.0.1:$AnalyticsHostPort/analytics/financial-bleed" `
    -ContentType "application/json" `
    -Body '{"period":"2026-01"}' | ConvertTo-Json -Compress

Write-Host "`nOptional Ollama (large Docker image): stack/compose.ollama.yml" -ForegroundColor Gray
Write-Host "Or native Windows Ollama: scripts/setup-ollama-windows.ps1" -ForegroundColor Gray

Write-Host "`nLocal stack smoke OK." -ForegroundColor Green
