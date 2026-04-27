# Pull a small CPU model into the Ollama container (Step 7 helper).
# Prereq: verify-local-stack.ps1 (or compose) running with `ollama` service.
#
#   powershell -ExecutionPolicy Bypass -File "d:\bright_info\solution\scripts\setup-ollama-model.ps1"

$ErrorActionPreference = "Stop"
$SolutionDir = Split-Path $PSScriptRoot -Parent
Set-Location $SolutionDir

$model = if ($env:OLLAMA_MODEL) { $env:OLLAMA_MODEL } else { "tinyllama" }

Write-Host "Pulling Ollama model inside Docker: $model" -ForegroundColor Cyan
docker compose -f docker-compose.yml -f stack/compose.stack.yml -f stack/compose.ollama.yml exec -T ollama ollama pull $model

Write-Host "`nSmoke generation:" -ForegroundColor Cyan
docker compose -f docker-compose.yml -f stack/compose.stack.yml -f stack/compose.ollama.yml exec -T ollama ollama run $model "Reply with exactly: OK"

Write-Host "`nOllama model step OK." -ForegroundColor Green
