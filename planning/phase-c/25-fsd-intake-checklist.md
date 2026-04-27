# FSD intake checklist (Step 25)

**Purpose:** Confirm the client’s Functional Specification is **complete enough** for fixed-scope pricing, build, and UAT. Replace `[ ]` with dates/initials when satisfied.

## A. Scope and phases

- [ ] **Phase 1 (pilot) scope** listed explicitly (e.g. financial KPIs only).
- [ ] **Phase 2** clearly marked optional / out of pilot (e.g. Arabic operational NLP, extra integrations).
- [ ] **Out of scope** statement (e.g. real ERP write-back, n8n unless agreed).

## B. Data and formulas

- [ ] Every **KPI** named with **exact formula** and **data sources** (Tally field / CSV column).
- [ ] **Calendar / fiscal** assumptions (month, year, currency QAR, rounding rules).
- [ ] **Sample data** (sanitized) representative of production shapes.
- [ ] **Refresh cadence** (daily/weekly) and who owns the export.

## C. Interface and quality

- [ ] **API contract** or examples: request/response JSON for each tool (or agreement to our OpenAPI as baseline).
- [ ] **Dify / chat**: languages, style, and **prohibited** claims (e.g. no investment advice) if any.
- [ ] **Arabic NLP (Phase 2):** if mentioned, test set size and **evaluation method** (not a vague “85% F1” without data).

## D. Security and compliance (inputs to design)

- [ ] **Data residency** and hosting constraints (Qatar / region).
- [ ] **RBAC** roles to support (e.g. CEO, read-only).
- [ ] **Logging/retention** expectations at pilot.
- [ ] **PDPPL / NCSA** as *requirements* vs *principles* (for legal review).

## E. UAT and acceptance

- [ ] **Test scenarios** or acceptance criteria for Phase 1 (numbered).
- [ ] **Exit criteria** for pilot sign-off (who signs — see `34-acceptance-signoff-template.md`).

## Sign-off (internal)

| Item | Status | Owner | Date |
|------|--------|-------|------|
| FSD received from client | [ ] | [Name] | |
| Technical review complete | [ ] | [Name] | |
| Gaps to client (if any) | [ ] N/A or ticket ref | [Name] | |

**Master plan Step 25** is “receive FSD” — track receipt above; do not commit client FSD to a public repository.
