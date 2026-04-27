# Step 7 (lightweight): use native Windows Ollama if installed (no Docker multi‑GB pull).
# Install from https://ollama.com/download then run:
#   powershell -ExecutionPolicy Bypass -File "d:\bright_info\solution\scripts\setup-ollama-windows.ps1"

$ErrorActionPreference = "Stop"

$ollama = Get-Command ollama -ErrorAction SilentlyContinue
if (-not $ollama) {
    throw "Ollama CLI not found on PATH. Install Ollama for Windows, then re-run this script."
}

$model = if ($env:OLLAMA_MODEL) { $env:OLLAMA_MODEL } else { "tinyllama" }

Write-Host "Pulling model: $model" -ForegroundColor Cyan
& ollama pull $model

Write-Host "`nSmoke run:" -ForegroundColor Cyan
& ollama run $model "Reply with exactly: OK"

Write-Host "`nOllama (Windows) step OK." -ForegroundColor Green
