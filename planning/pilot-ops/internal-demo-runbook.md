# Internal demo runbook (Phase A prototype — Steps 1–15)

Audience: internal stakeholders / quick CEO-style demo on a laptop.

**Draft solution screenshots (Playwright, mock + optional live):** `planning/demos/draft-solution-demo/README.md` — run `npm run test:mock` for slides without Docker; `npm test` after the stack is up for Swagger/health shots.

**Stakeholder narrative (3 use cases, filled mock JSON):** `planning/presentation/full-demo-scenario.md` (master plan step **15a**).

## Prereqs

- Docker Desktop healthy (`docker info` shows Server section)
- Git + PowerShell

## 1) Warehouse + sample data

```powershell
cd d:\bright_info\solution
docker compose up -d --wait
powershell -ExecutionPolicy Bypass -File .\scripts\verify-step1b.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\load-sample-financial-data.ps1
```

## 2) Deterministic analytics API (host)

```powershell
cd d:\bright_info\solution\analytics
python -m pip install -r requirements.txt
Copy-Item ..\.env.example .\.env
$env:DATABASE_URL = "postgresql://warehouse:warehouse_dev_change_me@127.0.0.1:55432/warehouse"
python -m uvicorn app.main:app --host 127.0.0.1 --port 8001
```

Smoke:

```powershell
Invoke-RestMethod http://127.0.0.1:8001/health/db
Invoke-RestMethod -Method Post http://127.0.0.1:8001/analytics/financial-bleed -ContentType application/json -Body '{"period":"2026-01"}'
```

## 3) Automated contract tests (Step 6)

```powershell
cd d:\bright_info\solution\analytics
python -m pip install -r requirements-dev.txt
python -m pytest -q
```

## 4) Full local stack: warehouse + analytics (Steps 7–10 helpers)

Compose publishes analytics on **host port `18001`** (maps to container `8001`) so requests to `127.0.0.1:8001` are not accidentally handled by another local dev server on Windows.

```powershell
cd d:\bright_info\solution
powershell -ExecutionPolicy Bypass -File .\scripts\verify-local-stack.ps1
```

After it succeeds, optional manual checks:

```powershell
Invoke-RestMethod http://127.0.0.1:18001/health/db
Invoke-RestMethod -Method Post http://127.0.0.1:18001/analytics/financial-bleed -ContentType application/json -Body '{"period":"2026-01"}'
```

Ollama (Step 7) — pick one:

- **Recommended (small footprint):** Windows native Ollama + `scripts/setup-ollama-windows.ps1`
- **Docker (large download):** add `stack/compose.ollama.yml` + `scripts/setup-ollama-model.ps1`

## 5) Dify (optional UI layer)

```powershell
powershell -ExecutionPolicy Bypass -File d:\bright_info\solution\scripts\bootstrap-dify.ps1
```

Then follow `solution\dify\README.md` + `solution\dify\INTEGRATION.md`.

## 6) Storyline (30 seconds)

1. “We ingest finance rows into Postgres (CSV for pilot).”
2. “FastAPI computes KPIs deterministically — the LLM never calculates money.”
3. “Dify is the conversational shell; it calls FastAPI as a tool.”

## 7) Recording checklist

- Show `fact_transactions` has rows (`/health/db`)
- Show `financial-bleed` JSON for `2026-01` vs `2026-02`
- (Optional) show Dify answering using tool JSON only
