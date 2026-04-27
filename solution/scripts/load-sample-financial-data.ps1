# Step 2: load sample financial CSV into fact_transactions.
# Run:
#   powershell -ExecutionPolicy Bypass -File "d:\bright_info\solution\scripts\load-sample-financial-data.ps1"

$ErrorActionPreference = "Stop"
$SolutionDir = Split-Path $PSScriptRoot -Parent
$CsvPath = Join-Path $SolutionDir "sample_data\financial_sample.csv"
$ContainerName = "bright_warehouse"
$ContainerCsv = "/tmp/financial_sample.csv"

if (-not (Test-Path $CsvPath)) {
    throw "Missing sample CSV: $CsvPath"
}

Set-Location $SolutionDir

Write-Host "== ensure warehouse container is up ==" -ForegroundColor Cyan
docker compose up -d --wait

Write-Host "`n== clear previous sample rows ==" -ForegroundColor Cyan
docker compose exec -T warehouse psql -U warehouse -d warehouse -c "DELETE FROM fact_transactions WHERE source_system = 'csv_finance_sample';"
if ($LASTEXITCODE -ne 0) { throw "Failed to clear previous sample rows." }

Write-Host "`n== copy CSV file into container ==" -ForegroundColor Cyan
docker cp "$CsvPath" "${ContainerName}:$ContainerCsv"
if ($LASTEXITCODE -ne 0) { throw "Failed to copy CSV into container." }

Write-Host "`n== load CSV into fact_transactions ==" -ForegroundColor Cyan
$copyFromFileSql = "COPY fact_transactions (txn_date, account_type, amount_qar, category, source_system) FROM '$ContainerCsv' WITH (FORMAT csv, HEADER true)"
docker compose exec -T warehouse psql -U warehouse -d warehouse -c $copyFromFileSql
if ($LASTEXITCODE -ne 0) { throw "Failed to load CSV into fact_transactions." }

Write-Host "`n== verify loaded rows ==" -ForegroundColor Cyan
docker compose exec -T warehouse psql -U warehouse -d warehouse -c "SELECT txn_date, account_type, amount_qar, category, source_system FROM fact_transactions WHERE source_system = 'csv_finance_sample' ORDER BY txn_date, id;"

$rowCount = docker compose exec -T warehouse psql -U warehouse -d warehouse -t -A -c "SELECT COUNT(*) FROM fact_transactions WHERE source_system = 'csv_finance_sample';"
if ($LASTEXITCODE -ne 0) { throw "Failed to query sample row count." }
$rowCount = [int]($rowCount.Trim())
Write-Host "Loaded sample rows: $rowCount"

if ($rowCount -le 0) {
    throw "Step 2 failed: no sample rows were loaded."
}

Write-Host "`n== cleanup temp CSV inside container ==" -ForegroundColor Cyan
docker compose exec -T warehouse sh -lc "rm -f $ContainerCsv" | Out-Null

Write-Host "`nStep 2 OK: sample CSV loaded into fact_transactions." -ForegroundColor Green
