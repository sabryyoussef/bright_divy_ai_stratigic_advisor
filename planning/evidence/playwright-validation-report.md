# Playwright Validation Report

Date: 2026-04-27  
Scope: Local prototype validation for analytics service and seeded warehouse data.

## Environment

- Workspace: `d:\bright_info`
- Stack: `solution/docker-compose.yml` + `solution/stack/compose.stack.yml`
- Analytics host URL: `http://127.0.0.1:18001`
- Seeded rows in `fact_transactions`: `7`

## Executed Checks

1. Stack smoke script
   - Command: `powershell -ExecutionPolicy Bypass -File "d:\bright_info\solution\scripts\verify-local-stack.ps1"`
   - Result: PASS
   - Verified:
     - `GET /health` -> status `ok`
     - `GET /health/db` -> db connected, 7 rows
     - `POST /analytics/financial-bleed` (period `2026-01`) -> deterministic negative net result

2. Contract tests
   - Command: `python -m pytest -q` (run in `solution/analytics`)
   - Result: PASS (`4 passed`)
   - Notes: warnings only (Python 3.14 deprecation warnings from FastAPI/Starlette internals)

3. Playwright browser evidence capture
   - Browser install command: `npx -y playwright@latest install chromium`
   - Screenshot commands:
     - `npx -y playwright@latest screenshot --browser=chromium http://127.0.0.1:18001/docs d:\bright_info\planning\evidence-docs-18001.png`
     - `npx -y playwright@latest screenshot --browser=chromium http://127.0.0.1:18001/health/db d:\bright_info\planning\evidence-health-db-18001.png`
     - `npx -y playwright@latest screenshot --browser=chromium http://127.0.0.1:18001/openapi.json d:\bright_info\planning\evidence-openapi-18001.png`
   - Result: PASS

## Evidence Files

- `planning/evidence-docs-18001.png`
- `planning/evidence-health-db-18001.png`
- `planning/evidence-openapi-18001.png`

## Conclusion

The local Phase A prototype stack is validated and reproducible with scripted startup + API checks.  
Service endpoints are reachable on host port `18001`, DB integration is healthy, deterministic KPI endpoint is functioning, and Playwright screenshots were captured as test evidence.
