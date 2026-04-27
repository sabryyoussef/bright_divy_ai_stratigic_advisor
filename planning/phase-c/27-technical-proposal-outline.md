# Technical proposal — outline (≤ 10 pages target; Step 27)

**Instructions:** Flesh out each section; keep **Phase 1 vs Phase 2** honest. Export to PDF for submission.

1. **Executive summary (1 p.)**  
   - Objectives, differentiators (deterministic core, self-hosted, bilingual path).

2. **Context & requirements**  
   - Restate FSD **must-haves** by reference; assumptions **explicitly** listed.

3. **Solution architecture**  
   - Diagram: CEO → Dify → HTTP tools → **FastAPI** → **PostgreSQL**; LLM for wording only.  
   - Point to `planning/pilot-ops/pilot-network-architecture.md` for network posture.

4. **Data**  
   - Warehouse model (facts/dimensions at high level), CSV ingest path, refresh cadence.

5. **Deterministic analytics**  
   - No LLM arithmetic; API examples; test strategy (pytest + UAT).

6. **Conversational layer**  
   - Dify role; tool calling; **guardrails** (system prompt; link `solution/dify/prompts/` if applicable).

7. **Arabic & Phase 2 NLP**  
   - Phase 1: formatting / bilingual copy from server facts.  
   - Phase 2: scope, dependencies on **client test set**, no fake precision.

8. **Security & operations**  
   - RBAC, audit logs, secrets, backup — summarize; detail in appendices if needed.  
   - PDPPL / NCSA: **governance and controls**, not a guarantee of certification.

9. **Delivery plan (Gantt-style table)**  
   - Weeks / milestones: env, ingest, API hardening, UAT, training, go-live.

10. **Risks & mitigations**  
   - Example: formula changes FSD, data quality, resource availability.

11. **Appendix (not counted in 10 p. if required)**  
   - OpenAPI excerpt, Glossary, References.

**Internal:** keep version and filename: `Proposal-[CLIENT]-v1.0-YYYYMMDD.pdf`
