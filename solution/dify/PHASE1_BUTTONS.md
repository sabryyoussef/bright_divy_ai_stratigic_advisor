# Phase 1 — “One-click” buttons (UI confirmation only)

Goal: buttons that **do not** trigger real financial transactions in Phase 1. They should only:

- confirm intent,
- route to a canned response / next workflow step,
- or open a human workflow (email/task) later.

## Dify UI guidance (practical)

1. In the **Chatflow / Workflow** canvas, add a **Question** node or **Answer** node with **quick replies** / **suggested options** (wording depends on Dify version).
2. Map each option to:
   - a **no-op** branch (recommended), or
   - a **stub HTTP** call that returns `{ "status": "ack" }` from FastAPI (optional future endpoint).
3. Label buttons clearly as **“Confirm (Phase 1)”** so users do not assume execution.

## What to avoid in Phase 1

- Calling payment / payroll / ERP write APIs
- “Auto-fix bleed” actions without human approval

## Optional future endpoint (not required now)

`POST /actions/ack` returning `{ "received": true }` — only if you want an auditable click trail.
