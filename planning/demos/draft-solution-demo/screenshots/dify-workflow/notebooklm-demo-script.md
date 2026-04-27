# AI Strategic Advisor Demo Script (NotebookLM)

Use this document as the narration script in NotebookLM.  
It explains the full journey from planning to live Dify workflow, with screenshot references.

---

## 1) Project Goal

We built a local prototype for an **AI Strategic Advisor** that combines:

- A financial analytics API (`FastAPI`)
- A warehouse database (`PostgreSQL`)
- A local LLM runtime (`Ollama`)
- A conversational orchestration layer (`Dify`)

The objective is to answer executive questions with factual, tool-based outputs, not hallucinated numbers.

---

## 2) Planning and Execution Structure

Work was managed through `planning/solution-build-master-steps.md` with phased execution:

- **Phase A (Local prototype):** API, DB, tests, Dify wiring, prompts, guardrails, demo assets.
- **Phase B (Pilot readiness):** network architecture, RBAC, audit logging, runbooks.
- **Phase C (RFQ and delivery):** proposal templates, checklists, handover artifacts.

We also reorganized the workspace so planning, evidence, demos, and presentation assets are easier to follow.

---

## 3) Core Build Completed

### Analytics + Data Layer

- Brought up `PostgreSQL` + `FastAPI` in Docker.
- Added contract tests for `/analytics/financial-bleed`.
- Added bilingual formatting checks (EN/AR).
- Added request audit middleware for compliance traceability.

### LLM + Dify Layer

- Started `Ollama` and pulled `qwen2.5:0.5b`.
- Started Dify Docker stack and resolved local port collisions.
- Prepared OpenAPI tool file:
  - `solution/dify/openapi/financial-bleed-tool.openapi.json`
- Prepared system guardrails prompt:
  - `solution/dify/prompts/system-ceo-advisor.md`
- Created and configured Dify app:
  - `CEO Strategic Advisor - Demo Agent`

---

## 4) Key Technical Issues Solved

During implementation we solved blockers that are common in real projects:

- Host port collisions on Windows (`8001`, `8080`) fixed by remapping (`18001`, `18080`).
- Ollama large-model pull timeout mitigated by switching to a smaller demo model.
- Dify API auth flow handled correctly (encoded password + CSRF token).
- DSL vs OpenAPI import confusion resolved:
  - **DSL import** is for full Dify app definitions.
  - **OpenAPI import** is for tools inside an app.

These fixes are part of the delivery maturity and make the demo reproducible.

---

## 5) Visual Validation with Playwright

We used Playwright to produce evidence screenshots in:

- `planning/demos/draft-solution-demo/screenshots/`

### A) Mock storyboard evidence

1. Desktop storyboard:
   - `01-mock-storyboard-desktop.png`
2. Mobile storyboard:
   - `02-mock-storyboard-mobile.png`

These communicate the scenario flow before live interaction.

### B) Live API evidence

3. Swagger docs live:
   - `10-live-swagger-docs.png`
4. Health DB endpoint:
   - `11-live-health-db.png`
5. OpenAPI JSON endpoint:
   - `12-live-openapi-json.png`

These prove the backend is running and reachable.

---

## 6) Dify Workflow Walkthrough (Final Demo)

### Step 1: Sign in to Dify

- Screenshot: `20-dify-signin-filled.png`
- Meaning: demo account credentials are entered, system ready for operation.

### Step 2: Dify apps home

- Screenshot: `21-dify-apps-home.png`
- Meaning: we reached the workspace and app catalog successfully.

### Step 3: Open strategic advisor agent

- Screenshot: `22-dify-agent-open.png`
- Meaning: `CEO Strategic Advisor - Demo Agent` is accessible for run/debug.

### Step 4: Workflow run screen (final state)

- Screenshot: `23-dify-workflow-run.png`
- Meaning: this is the final workflow capture showing the Dify agent context prepared for executive Q&A.

This is the final screenshot to use as the end of the story.

---

## 7) Suggested Narration (Short Version)

We designed and built a local AI Strategic Advisor stack end-to-end.  
Starting with structured planning, we implemented the analytics API, database integration, and bilingual output checks.  
Then we connected Dify with Ollama and our OpenAPI tool while applying strict prompt guardrails for factual responses.  
We validated each layer visually using Playwright: storyboard, live API, and finally the Dify workflow UI.  
The final workflow screenshot confirms the assistant environment is ready for a stakeholder demo and client conversation.

---

## 8) Suggested Narration (Client-Facing Version)

This prototype demonstrates how leadership can ask strategic finance questions and receive grounded, explainable answers from enterprise data.  
The architecture combines a governed analytics service, a controlled LLM runtime, and an orchestration layer designed for operational rollout.  
We included auditability, deployment runbooks, security design inputs, and RFQ-ready delivery templates.  
The attached screenshots show the full maturity path from planning artifacts, to live API validation, to the final Dify workflow execution view.

---

## 9) NotebookLM Upload Checklist

Upload these files first:

- `planning/presentation/notebooklm-demo-script.md` (this file)
- `planning/solution-build-master-steps.md`
- `planning/presentation/full-demo-scenario.md`
- `planning/presentation/speaker-outline.md`
- All screenshots under `planning/demos/draft-solution-demo/screenshots/`

Then ask NotebookLM to generate:

1. A 5-minute executive summary
2. A 15-minute detailed demo talk track
3. A Q&A sheet for expected client questions

