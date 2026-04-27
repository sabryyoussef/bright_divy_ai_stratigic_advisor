# Full demo scenario (filled mock) — Strategic CEO advisor (pilot)

**Version:** 1.0 (for presentation)  
**Data file:** `solution/sample_data/financial_sample.csv` (7 rows, `source_system = csv_finance_sample`)  
**Fictional context:** A **leadership academy** runs a 60-day pilot: daily/weekly **Tally (or manual) CSV** lands in a private **Postgres warehouse**; a **self-hosted** stack answers the CEO in **English or Arabic** with **no public-cloud LLM** for business numbers (per RFQ direction).

---

## 1. Dataset (what the numbers are)

| Month   | Revenue (QAR) | Expense (QAR) | Net (QAR) | Notes (from sample file) |
|---------|---------------|-----------------|-----------|----------------------------|
| 2026-01 | 50,000        | 65,500          | **−15,500** | One revenue line; payroll + marketing drive cost. |
| 2026-02 | 63,000        | 45,000          | **+18,000** | Revenue: lessons 55k + add-on 8k; expense: payroll 40k + fuel 5k. |

**Row count in warehouse (pilot load):** **7** — see `uc3-health-db.json` and `GET /health/db`.

**Important for the client:** All KPIs in the demo are **recomputed in SQL** by the analytics service. The LLM (if shown) may **rephrase** the answer but must take **numeric facts** from the tool JSON only.

---

## 2. Use case 1 — “Are we bleeding money this month?” (January)

**Persona:** CEO  
**Intent:** One clear period, one clear outcome: **loss or not**, and **where cost pressure is**.

**Sample user questions (EN):**
- “Did we have a **financial bleed** in **January 2026**?”
- “What were the **top cost drivers** in January?”

**API (deterministic):**
- `POST /analytics/financial-bleed`  
- Body: `{ "period": "2026-01" }`

**Expected tool / API result (summary):**
- Net **−15,500 QAR** → **bleed = true**  
- Top expense categories: **payroll** (−62,000), **marketing** (−3,500) — as in `mock-api/uc1-financial-bleed-2026-01.json`

**What to say in the room (1–2 sentences):**  
“January is **net negative**; the model is not guessing—**payroll and marketing** are the two largest expense buckets we see in the pilot extract.”

**Sample user questions (AR)** — same numbers must appear in the answer:  
- «هل كان هناك **تراجع مالي** في **يناير 2026**؟»  
- «ما أكبر بنود التكلفة في يناير؟»

*(Implementation note: bilingual **copy** helpers live in `solution/analytics/app/formatting.py`; the **digits** always come from the JSON.)*

---

## 3. Use case 2 — “Did we recover in February?” (comparison narrative)

**Persona:** CEO or CFO delegate  
**Intent:** Compare **February** performance to **January** using the **same definition** of revenue/expense/net.

**Sample user questions (EN):**
- “How did **February 2026** look versus January?”
- “Is February **cash-positive** after January’s loss?”

**API calls:**
1. `POST ... financial-bleed` `{ "period": "2026-02" }`  
2. (Optional) Repeat for `2026-01` if the assistant does not cache—**two deterministic calls**.

**Expected results:**
- January: net **−15,500**, bleed **yes** (`uc1`).  
- February: net **+18,000**, bleed **no** (`uc2`).

**Talking point:** February shows **recovery**: higher recognized revenue (including **add-on services**) and lower total expense versus January in this **mock** slice.

---

## 4. Use case 3 — “Is our pilot data actually loaded and connected?”

**Persona:** CIO / sponsor / auditor in the room  
**Intent:** Prove **connectivity** and **batch completeness** before trusting any KPI story.

**Sample user questions:**
- “Do we actually have pilot transactions in the warehouse?”
- “How many rows are feeding the KPI engine?”

**API:**
- `GET /health/db`

**Expected:** `db_connected: true`, `fact_transactions_rows: **7**` — see `mock-api/uc3-health-db.json`.

**Bridge to security:** Private DB, no public Postgres; details in `planning/pilot-ops/pilot-network-architecture.md`.

---

## 5. Optional Dify + LLM path (same three use cases)

If you demo the **conversation shell**:

1. User asks in natural language (EN or AR).  
2. Workflow calls the **same HTTP tool** → FastAPI JSON above.  
3. LLM produces **natural language** using **only** those fields (system prompt in `solution/dify/prompts/system-ceo-advisor.md`).  
4. **Phase 1 buttons:** confirmation-only UI — see `solution/dify/PHASE1_BUTTONS.md`.

---

## 6. Slide checklist (minimum)

| # | Slide |
|---|--------|
| 1 | Problem + principle (no LLM math for money) |
| 2 | Architecture (CSV → Postgres → FastAPI → optional Dify/LLM) |
| 3 | UC1 — January bleed + drivers (`uc1` JSON snippet) |
| 4 | UC2 — February recovery (`uc2` JSON snippet) |
| 5 | UC3 — `/health/db` + row count (`uc3`) |
| 6 | Governance — VPC, RBAC, audit (`pilot-ops` pointers) |
| 7 | Next step — NDA → FSD → fixed Phase 1 scope |

---

## 7. Files to show live or as screenshots

| Asset | Location |
|-------|-----------|
| Mock JSON (all UCs) | `planning/presentation/mock-api/` |
| Playwright screenshots | `planning/demos/draft-solution-demo/screenshots/` |
| Run order | `planning/pilot-ops/internal-demo-runbook.md` |

---

**Disclaimer:** This scenario uses **fixed sample data** for a **presentation**. Production scope, formulas, and acceptance tests follow the client **FSD** after NDA.
