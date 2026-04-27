# Pricing table (Step 28)

**Confidential — do not commit client-specific final numbers to public Git if your policy forbids it.** This file is a **structure**; copy to a private store for real values.

| Line | Description | Phase | Type | Qty | Unit | Subtotal (QAR) | Notes / assumptions |
|------|-------------|------|------|-----|------|----------------|----------------------|
| P1-01 | Discovery + FSD alignment | 1 | Fixed | 1 | project | [ ] | [days or weeks] |
| P1-02 | Design + warehouse + ETL/CSV | 1 | Fixed | 1 | project | [ ] | [ ] |
| P1-03 | FastAPI + deterministic KPIs | 1 | Fixed | 1 | project | [ ] | [ ] |
| P1-04 | Dify setup + tool wiring + guardrails | 1 | Fixed | 1 | project | [ ] | [ ] |
| P1-05 | Ollama / LLM baseline | 1 | Fixed | 1 | project | [ ] | [ ] |
| P1-06 | UAT support + fixes (within cap) | 1 | Fixed | 1 | project | [ ] | e.g. N days UAT support |
| P1-07 | Training + handover | 1 | Fixed | 1 | project | [ ] | [ ] |
| P2-01 | n8n / additional integrations | 2 | Option | 1 | project | [ ] | Off by default |
| P2-02 | Arabic operational NLP (beyond Phase 1) | 2 | Option | 1 | project | [ ] | **Requires** client test set + agreement on metrics |
| M-01 | Maintenance (Year 1) | 1+ | retainer / optional | 12 | month | [ ] | See `29-maintenance-sla-template.md` |

**Assumptions (must be signed off)**

- FSD is stable after version [X]; **change request** = time + materials or change order.  
- Pilot data via **CSV** as per FSD; any API to Tally/Adler is [in / out] of scope.  
- [Hosting]: client provides VPC / or we host in [region] for [fee].  
- [Support hours]: e.g. business hours GCC.

**Total Phase 1 (excl. VAT):** [ ] QAR
