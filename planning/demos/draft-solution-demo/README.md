# Draft solution — visual demo (Playwright + mock data)

Use this pack to generate **presentation screenshots** for the RFQ draft: a **mock KPI storyboard** (no running API) plus **optional live** shots of Swagger, `/health/db`, and OpenAPI when the stack is up.

## What you get

| Output (in `screenshots/`) | Source |
|----------------------------|--------|
| `01-mock-storyboard-desktop.png` | HTML built from `mock/*.json` (same shapes as the real API) |
| `02-mock-storyboard-mobile.png` | Same, narrow viewport |
| `10-live-swagger-docs.png` | Live: `http://127.0.0.1:18001/docs` (if stack running) |
| `11-live-health-db.png` | Live: `/health/db` |
| `12-live-openapi-json.png` | Live: `/openapi.json` |

**Mock data** matches the sample pipeline (`solution/sample_data/financial_sample.csv` → 7 rows, January bleed scenario).

## One-time setup

```powershell
cd d:\bright_info\planning\demos\draft-solution-demo
npm install
npx playwright install chromium
```

## Generate screenshots (mock only — no Docker)

```powershell
npm run test:mock
```

## Full run (mock + live)

1. Start warehouse + analytics and load sample data (as in `../../pilot-ops/internal-demo-runbook.md`).
2. Run:

```powershell
npm test
```

Live tests **skip** automatically if `127.0.0.1:18001` is down; mock tests always run.

## Scripts

| Command | Action |
|--------|--------|
| `npm run test:mock` | `mock-storyboard` specs only |
| `npm test` | All tests (mock + live with skip) |
| `npm run test:live` | `cross-env LIVE_API=1` reserved for future use; use `npm test` |

## Slide order (suggested)

1. `01-mock-storyboard-desktop` — **story** (flow + KPI + JSON)  
2. `10`–`12` or earlier Playwright evidence — **proof of running API**  
3. `docs/phase-c` and `pilot-network-architecture` for security / RFQ

## See also

- **Full 3-use-case narrative + canonical mock JSON:** `../../presentation/full-demo-scenario.md` and `../../presentation/mock-api/`
- `planning/pilot-ops/internal-demo-runbook.md`
- `planning/phase-c/README.md`
- `planning/solution-build-master-steps.md`
