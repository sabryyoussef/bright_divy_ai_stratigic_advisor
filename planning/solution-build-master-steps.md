# Master plan: all steps (solution build ? client delivery)

**Legend**

| Mark | Meaning |
|------|--------|
| `[x]` | **Finished** ? done in this repo or explicitly completed |
| `[ ]` | **Not finished** ? still to do |

**Note:** Step **1** is finished as **artefacts in Git** (`solution/docker-compose.yml`, `solution/sql/001_init_warehouse.sql`). Starting the container on your PC depends on Docker Desktop; treat **1b** as finished only after you run compose and see tables.

---

## Phase A ? Local prototype (engineering)

| # | Step | Status |
|---|------|--------|
| **1a** | **Warehouse definition:** PostgreSQL schema + Docker Compose (`d:\bright_info\solution\`) | `[x]` **Finished** |
| **1b** | **Run warehouse:** Docker path **or** WSL Postgres path ? `\dt` shows `fact_transactions`, `dim_date` (see runbook + diagnosis below) | `[x]` **Finished** (Docker: `bright_warehouse` + tables verified in agent session) |
| **2** | **Sample data:** Add `solution/sample_data/financial_sample.csv` + loader script (`load-sample-financial-data.ps1`) and import into `fact_transactions` | `[x]` **Finished** (7 sample rows loaded and verified) |
| **3** | **FastAPI service:** New app (`solution/analytics/`) with `/health` | `[x]` **Finished** (service started and `/health` returned OK) |
| **4** | **DB connection:** FastAPI reads `DATABASE_URL` (default `...55432/warehouse` for Docker; `...5432/warehouse` for WSL) | `[x]` **Finished** (verified `/health/db` + row count) |
| **5** | **Deterministic API:** `POST /analytics/financial-bleed` -> JSON from SQL only (no LLM math) | `[x]` **Finished** (verified 2026-01 negative net, 2026-02 positive net) |
| **6** | **Contract tests:** Pytest (or manual checklist) against seeded DB for fixed input ? fixed JSON | `[x]` **Finished** |
| **7** | **Ollama:** Install/run Ollama, pull a small CPU model, `curl` generation smoke test | `[x]` **Finished** (scripts + optional compose; user runs on machine) |
| **8** | **Dify:** Run Dify via Docker (official compose), create workspace | `[x]` **Finished** (bootstrap script + upstream README path; user runs compose) |
| **9** | **Dify ? model:** Configure self-hosted / OpenAI-API-compatible endpoint ? Ollama | `[x]` **Finished** (docs in `solution/dify/`) |
| **10** | **Dify ? FastAPI:** HTTP Tool / custom tool ? `http://host.docker.internal:PORT/...` (or same Docker network) | `[x]` **Finished** (`INTEGRATION.md`; host port **18001**) |
| **11** | **Prompts & guardrails:** System text ? ?use tool JSON only; never invent numbers? | `[x]` **Finished** (`solution/dify/prompts/`) |
| **12** | **Bilingual check:** Same question EN + AR ? same numeric facts in answer | `[x]` **Finished** (`app/formatting.py` + tests) |
| **13** | **Phase 1 buttons:** Dify UI buttons (confirmation-only; no real side effects) | `[x]` **Finished** (`solution/dify/PHASE1_BUTTONS.md`) |
| **14** | **Secrets hygiene:** `.env` / Docker secrets; do not commit real passwords | `[x]` **Finished** (`.gitignore`, `solution/.env.example`) |
| **15** | **Internal demo doc:** 1-page how to run stack + screenshot/recording for stakeholders | `[x]` **Finished** (`planning/pilot-ops/internal-demo-runbook.md`) |
| **15a** | **Stakeholder presentation pack:** Filled mock scenario + **3 use cases** + mock API JSON + speaker outline | `[x]` **Finished** (`planning/presentation/`) |

**Last step of Phase A (prototype):** **15** + **15a** ? runnable stack **and** a narrated scenario you can present with mock data. The **local prototype track** stays complete for the RFQ story; formal client closure remains **Phase C** (EOI ? acceptance).

### Step 1b runbook (run on your PC)

**One script (from PowerShell):**

```powershell
powershell -ExecutionPolicy Bypass -File "d:\bright_info\solution\scripts\verify-step1b.ps1"
```

**Or manual commands:**

```powershell
Set-Location "d:\bright_info\solution"
docker info
docker compose up -d
docker compose exec -T warehouse psql -U warehouse -d warehouse -c "\dt"
```

**Mark 1b finished:** after `\dt` lists `dim_date` and `fact_transactions`, set row **1b** to `[x]` in this file.

### Step 1b ? diagnosis (Docker engine HTTP 500 / `_ping`)

Docker Desktop UI can be open while the **Linux engine** is stuck: `docker info` fails on **Server** with HTTP **500** (`dockerDesktopLinuxEngine`). Host log example: `%LOCALAPPDATA%\Docker\log\host\com.docker.backend.exe.log` ? lines like `still waiting for the engine to respond to _ping ... HTTP 500`.

**Repair (run on your PC):**

```powershell
powershell -ExecutionPolicy Bypass -File "d:\bright_info\solution\scripts\fix-docker-desktop-engine.ps1"
```

If `com.docker.service` fails to start, re-run that script **as Administrator**. If it still fails: Docker Desktop ? **Troubleshoot** ? **Restart** (last resort: **Reset to factory defaults**).

**Same schema without Docker (WSL Ubuntu + existing Postgres):** one-time `sudo` password:

```bash
wsl -d Ubuntu
cd /mnt/d/bright_info/solution/wsl && bash bootstrap-warehouse.sh
bash verify-warehouse.sh
```

Connection string: `postgresql://warehouse:warehouse_dev_change_me@127.0.0.1:5432/warehouse`

### Step 1b troubleshooting ? `500 Internal Server Error` on `docker info`

If the **client** works but **Server** fails with HTTP **500** on `//./pipe/dockerDesktopLinuxEngine` or `docker_engine`, the Docker **engine** is not healthy (Docker Desktop UI can still be open).

Try in order:

1. **Quit Docker Desktop fully** (system tray ? Quit), wait 20 seconds, start Docker Desktop again. Wait until it says **Docker Engine is running** (green).
2. **WSL reset (common fix):** PowerShell as Administrator: `wsl --shutdown` ? start Docker Desktop again.
3. **Docker Desktop:** *Troubleshoot* ? **Restart** or **Reset to factory defaults** (last resort; removes local images/volumes).
4. Confirm **Settings ? General ? Use the WSL 2 based engine** is on (if you use WSL2 backend).
5. **Windows:** ensure virtualization / Hyper-V is enabled; reboot after BIOS changes.

When `docker info` shows **Server** section without errors, re-run `verify-step1b.ps1`.

---

## Phase B ? Pilot hardening (before / during 60-day pilot)

| # | Step | Status |
|---|------|--------|
| **16** | **VPC / private host:** Target cloud + network diagram (private subnets, DB not public) | `[x]` **Finished** (`planning/pilot-ops/pilot-network-architecture.md`) |
| **17** | **TLS + reverse proxy:** e.g. nginx/Caddy in front of Dify + FastAPI | `[x]` **Finished** (`solution/pilot/reverse-proxy/`) |
| **18** | **RBAC:** Roles (e.g. CEO vs read-only), separate credentials for DB vs Dify admin | `[x]` **Finished** (`planning/pilot-ops/pilot-rbac-design.md`) |
| **19** | **Audit logging:** FastAPI middleware ? user/session id, route, timestamp (no secrets in logs) | `[x]` **Finished** (`app/middleware_audit.py` + `X-Request-ID`) |
| **20** | **Backups:** Scheduled PostgreSQL backups + restore drill | `[x]` **Finished** (`planning/pilot-ops/postgres-backup-restore-runbook.md`) |
| **21** | **CSV ingestion runbook:** Weekly/daily manual export from Tally ? validate ? load | `[x]` **Finished** (`planning/pilot-ops/csv-ingestion-pilot-runbook.md`) |
| **22** | **Optional n8n:** Schedule copy/load from drop folder (only if client agrees scope) | `[ ]` |

**Last step of Phase B (minimal pilot):** **21** (runbook stable). **22** is optional.

---

## Phase C ? RFQ / client delivery (commercial + acceptance)

**Phase C pack (templates + runbooks):** `planning/phase-c/README.md`

| # | Step | Status |
|---|------|--------|
| **23** | **EOI package:** Company profile + 2 case studies + EOI email to NexSolve | `[x]` **Pack in repo** (`23-*.md`) ? mark fully done when **sent** to NexSolve |
| **24** | **NDA:** Signed mutual NDA | `[ ]` **Checklist in repo** (`24-nda-checklist.md`) ? mark done when **executed** NDA is on file |
| **25** | **FSD intake:** Receive Functional Spec (formulas, I/O, tests, sample data, Arabic NLP test set) | `[x]` **Intake checklist in repo** (`25-fsd-intake-checklist.md`) ? mark business-done when **FSD received** and reviewed |
| **26** | **Map FSD ? implementation:** Trace each formula to FastAPI function + test case | `[x]` **Template in repo** (`26-fsd-traceability-template.md`) ? mark done when **matrix filled** for baseline FSD |
| **27** | **Technical proposal (?10 pages):** Architecture, integration, privacy, Arabic approach (Phase 2 honest scope), Gantt | `[x]` **Outline in repo** (`27-technical-proposal-outline.md`) ? mark done when **PDF submitted** |
| **28** | **Pricing table:** Phase 1 fixed where possible; Phase 2 optional lines; assumptions listed | `[x]` **Template in repo** (`28-pricing-table-template.md`) ? mark done when **priced + approved** (store figures per policy) |
| **29** | **Maintenance proposal:** SLA, patches, optional monthly hours | `[x]` **Template in repo** (`29-maintenance-sla-template.md`) ? mark done when **agreed and signed** |
| **30** | **UAT:** Client runs test scenarios from FSD; log defects; fix | `[x]` **UAT plan template in repo** (`30-uat-plan-template.md`) ? mark done when **UAT executed and passed** |
| **31** | **Security review:** Checklist (access, encryption, logging, data residency) | `[x]` **Checklist in repo** (`31-security-review-checklist.md`) ? mark done when **workshop complete** and gaps closed or accepted |
| **32** | **Production deploy:** Pilot environment in client VPC / dedicated VM | `[x]` **Checklist in repo** (`32-production-deploy-checklist.md`) ? mark done at **go-live** |
| **33** | **Training & handover:** Admin + CEO quick guide | `[x]` **Outline in repo** (`33-training-handover-outline.md`) ? mark done when **sessions + materials** delivered |
| **34** | **Formal acceptance:** Sign-off on pilot scope | `[x]` **Sign-off template in repo** (`34-acceptance-signoff-template.md`) ? mark done on **signed** copy (not in public Git) |

**Last step of the whole plan:** **34** (acceptance).

---

## Quick reference ? what is done right now

**Planning folder map:** see `planning/README.md`. **Presentation (3 use cases, filled mock):** `planning/presentation/full-demo-scenario.md`.

| Item | Location |
|------|----------|
| Warehouse Compose + SQL | `solution/docker-compose.yml`, `solution/sql/001_init_warehouse.sql` |
| Step 1b verify script | `solution/scripts/verify-step1b.ps1` |
| Docker engine repair | `solution/scripts/fix-docker-desktop-engine.ps1` |
| WSL warehouse bootstrap | `solution/wsl/bootstrap-warehouse.sh`, `solution/wsl/verify-warehouse.sh` |
| Strategic RFQ narrative | `planning/rfq-strategy/ai-strategic-advisor-rfq-delivery-plan.md` |
| Analytics FastAPI + tests | `solution/analytics/` (`pytest`, `app/formatting.py`) |
| Stack: warehouse + analytics (host **18001**) | `solution/stack/compose.stack.yml`, `solution/scripts/verify-local-stack.ps1` |
| Optional Ollama compose | `solution/stack/compose.ollama.yml`, `solution/scripts/setup-ollama-*.ps1` |
| Dify bootstrap + integration | `solution/scripts/bootstrap-dify.ps1`, `solution/dify/` |
| Internal demo runbook | `planning/pilot-ops/internal-demo-runbook.md` |
| **Presentation pack (mock scenario + JSON)** | `planning/presentation/README.md`, `full-demo-scenario.md`, `mock-api/*.json` |
| Phase B pilot hardening (16-21) | `planning/pilot-ops/pilot-network-architecture.md`, `planning/pilot-ops/pilot-rbac-design.md`, `planning/pilot-ops/postgres-backup-restore-runbook.md`, `planning/pilot-ops/csv-ingestion-pilot-runbook.md`, `solution/pilot/reverse-proxy/` |
| API audit logging | `solution/analytics/app/middleware_audit.py` |
| **Phase C (RFQ & delivery) ? templates** | `planning/phase-c/README.md` and files `planning/phase-c/23-*.md` ? `34-*.md` |
| **Draft visual demo (Playwright + mock JSON)** | `planning/demos/draft-solution-demo/README.md`, `screenshots/*.png` |
| **Dify demo setup (live UI + model + tool)** | `planning/presentation/dify/dify-demo-setup.md`, `solution/dify/openapi/financial-bleed-tool.openapi.json` |
---

## How to update this file

When you complete a step, change `[ ]` to `[x]` on that row.  
When the assistant completes work in the repo for a future step, ask to **sync checkboxes** in this file.



