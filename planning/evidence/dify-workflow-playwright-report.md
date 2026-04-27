# Dify Workflow Playwright Report

Date: 2026-04-27  
Environment: Local Docker (`Dify` on `http://127.0.0.1:18080`)

## What was automated

- Logged in to Dify with the demo account.
- Opened the app `CEO Strategic Advisor - Demo Agent`.
- Attempted to enter run/debug chat context and submit a demo prompt.
- Captured full-page screenshots for each key step.

## Automation file

- `planning/demos/draft-solution-demo/tests/dify-workflow-demo.spec.ts`

## Command used

```powershell
$env:DIFY_BASE_URL='http://127.0.0.1:18080'
$env:DIFY_EMAIL='vendorah2@gmail.com'
$env:DIFY_PASSWORD='Shabab28jan'
$env:DIFY_APP_NAME='CEO Strategic Advisor - Demo Agent'
npx playwright test tests/dify-workflow-demo.spec.ts
```

## Result

- Playwright status: **passed** (`1 passed`).
- Screenshot output path: `planning/demos/draft-solution-demo/screenshots/`

## Captured screenshots

- `20-dify-signin-filled.png`
- `21-dify-apps-home.png`
- `22-dify-agent-open.png`
- `23-dify-workflow-run.png`
