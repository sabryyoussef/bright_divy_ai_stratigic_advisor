# FSD → implementation traceability (Step 26)

**Purpose:** One row per **FSD item** (formula, report, or behaviour). Update after FSD is baselined.

| FSD ref / ID | Description | FastAPI / module | Test (file::test) or UAT # | Status |
|--------------|-------------|------------------|----------------------------|--------|
| FSD-1.0 | e.g. Financial bleed, period | `get_financial_bleed` / `app/db.py` | `tests/test_financial_bleed_contract.py` | [ ] |
| FSD-1.1 | [ ] | [ ] | [ ] | [ ] |
| FSD-2.0 | [ ] | [ ] | [ ] | [ ] |

**Notes**

- Add rows until every **must-have** FSD line has a test or explicit **manual** UAT step.
- “Status”: `not started` | `in dev` | `in test` | `in UAT` | `done`.

## Change control

| Date | FSD version | Change | Approved by |
|------|-------------|--------|-------------|
| [DATE] | v0.1 | Initial mapping | [Name] |
