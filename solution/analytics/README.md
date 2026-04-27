# Analytics Service (Step 3)

Minimal FastAPI service for deterministic analytics.

## Run locally

```powershell
cd d:\bright_info\solution\analytics
python -m pip install -r requirements.txt
python -m uvicorn app.main:app --host 0.0.0.0 --port 8001
```

## Health check

```powershell
Invoke-RestMethod http://127.0.0.1:8001/health
```

## Step 4 - Database connection

The service reads `DATABASE_URL` from environment.

- Docker warehouse default: `postgresql://warehouse:warehouse_dev_change_me@127.0.0.1:55432/warehouse` (see `docker-compose.yml`; high port avoids local Postgres on typical ports)
- WSL warehouse fallback: `postgresql://warehouse:warehouse_dev_change_me@127.0.0.1:5432/warehouse`

PowerShell example:

```powershell
$env:DATABASE_URL="postgresql://warehouse:warehouse_dev_change_me@127.0.0.1:55432/warehouse"
python -m uvicorn app.main:app --host 127.0.0.1 --port 8001
Invoke-RestMethod http://127.0.0.1:8001/health/db
```

## Step 5 - Financial bleed API

Deterministic endpoint:

```powershell
Invoke-RestMethod `
  -Method Post `
  -Uri http://127.0.0.1:8001/analytics/financial-bleed `
  -ContentType "application/json" `
  -Body '{"period":"2026-01"}'
```

## Step 6 - Contract tests

```powershell
cd d:\bright_info\solution\analytics
python -m pip install -r requirements-dev.txt
python -m pytest -q
```

## Steps 7-10 - Docker stack (warehouse + analytics)

Analytics is exposed on the host at **`http://127.0.0.1:18001`** when using `stack/compose.stack.yml` (container still listens on `8001`). Optional Ollama is a separate compose file.

See `../stack/README.md` and run:

```powershell
cd d:\bright_info\solution
powershell -ExecutionPolicy Bypass -File .\scripts\verify-local-stack.ps1
```

## Steps 11-13 - Dify prompts / integration / buttons

See `../dify/README.md`.

## Step 19 (pilot) - Audit logging

`app/middleware_audit.py` adds structured request logs (method, path, status, duration, client host) and an `X-Request-ID` response header. Health routes are not logged to avoid probe noise.

## Step 12 - Bilingual formatting (no LLM math)

Python helpers live in `app/formatting.py` (used by tests to ensure EN/AR strings share the same numeric tokens).
