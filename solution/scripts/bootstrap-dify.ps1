# Clone LangGenius Dify docker deployment into solution/vendor (gitignored).
# Run:
#   powershell -ExecutionPolicy Bypass -File "d:\bright_info\solution\scripts\bootstrap-dify.ps1"

$ErrorActionPreference = "Stop"
$SolutionDir = Split-Path $PSScriptRoot -Parent
$VendorRoot = Join-Path $SolutionDir "vendor"
$DifyDir = Join-Path $VendorRoot "dify-docker"

New-Item -ItemType Directory -Path $VendorRoot -Force | Out-Null

if (Test-Path (Join-Path $DifyDir ".git")) {
    Write-Host "Dify repo already exists at: $DifyDir" -ForegroundColor Yellow
    Write-Host "To update: cd `"$DifyDir`" ; git pull" -ForegroundColor Yellow
    exit 0
}

Write-Host "Cloning Dify docker deployment into:" -ForegroundColor Cyan
Write-Host $DifyDir

git clone --depth 1 https://github.com/langgenius/dify.git $DifyDir

Write-Host "`nNext:" -ForegroundColor Green
Write-Host "  cd `"$DifyDir\docker`"" -ForegroundColor White
Write-Host "  copy .env.example .env   (then edit secrets / URLs)" -ForegroundColor White
Write-Host "  docker compose up -d" -ForegroundColor White
Write-Host "`nThen wire Dify tools to analytics using: solution\dify\INTEGRATION.md" -ForegroundColor Gray
