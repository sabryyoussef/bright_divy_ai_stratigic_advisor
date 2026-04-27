# Speaker outline — mock-data solution demo (~15–20 min)

## 0. Hook (1 min)
- Problem: CEO needs **trusted** answers; LLM must **not** invent finance numbers.
- Our rule: **PostgreSQL + FastAPI = source of truth**; Dify/LLM = **language and workflow** only.

## 1. Data & setting (2 min)
- Pilot file: **`financial_sample.csv`** (Tally-style export fictionalized for RFQ).
- Show `planning/presentation/full-demo-scenario.md` § “Dataset” or one slide with row count **7**.

## 2. Use case 1 — Financial bleed (5 min)
- Question: “Did we lose money in **January 2026**?”
- Live or screenshot: **Swagger** `POST /analytics/financial-bleed` body `{"period":"2026-01"}`.
- Point to **`mock-api/uc1-*.json`** on slide: net **−15,500 QAR**, drivers **payroll / marketing**.

## 3. Use case 2 — Recovery month (4 min)
- Question: “How is **February** vs January?”
- Same endpoint `{"period":"2026-02"}` → net **+18,000 QAR**, no bleed.
- **`mock-api/uc2-*.json`**

## 4. Use case 3 — Trust & connectivity (3 min)
- **GET `/health/db`** → `fact_transactions_rows: 7`.
- **`mock-api/uc3-*.json`**
- Optional: same facts in **EN + AR** phrasing (no number change) — see full scenario doc.

## 5. Architecture (3 min)
- Point to diagram: CSV → warehouse → API → (optional) Dify + local LLM.
- `planning/pilot-ops/pilot-network-architecture.md` if security comes up.

## 6. Close (1 min)
- Phase 1 scope: **financial strategic KPIs** from agreed export; Phase 2 = more sources / Arabic NLP **after FSD**.

**Artifacts folder:** `planning/demos/draft-solution-demo/screenshots/` for visuals.
