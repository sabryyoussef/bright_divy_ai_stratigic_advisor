# Planning — index

Use this map to find documents quickly. The **master checklist** is always:

- **`solution-build-master-steps.md`**

---

## By topic

### Master & strategy
| Item | Path |
|------|------|
| Master step list (Phase A → C) | `solution-build-master-steps.md` |
| Arabic RFQ / delivery narrative | `rfq-strategy/ai-strategic-advisor-rfq-delivery-plan.md` |

### Presentation (filled mock — client-facing narrative)
| Item | Path |
|------|------|
| Index | `presentation/README.md` |
| **Full scenario + 3 use cases** | `presentation/full-demo-scenario.md` |
| Mock API JSON (slides / appendix) | `presentation/mock-api/` |
| Speaker outline | `presentation/speaker-outline.md` |

### Phase B — Pilot operations (runbooks)
| Item | Path |
|------|------|
| VPC / network | `pilot-ops/pilot-network-architecture.md` |
| RBAC | `pilot-ops/pilot-rbac-design.md` |
| Postgres backup / restore | `pilot-ops/postgres-backup-restore-runbook.md` |
| CSV pilot ingestion (Tally → warehouse) | `pilot-ops/csv-ingestion-pilot-runbook.md` |
| Internal demo (stack + pytest + screenshots) | `pilot-ops/internal-demo-runbook.md` |

### Phase C — RFQ / client delivery (templates)
| Item | Path |
|------|------|
| Index | `phase-c/README.md` |
| Steps 23–34 templates | `phase-c/23-*.md` … `phase-c/34-*.md` |

### Demos & evidence
| Item | Path |
|------|------|
| Playwright draft presentation + screenshots | `demos/draft-solution-demo/README.md` |
| Playwright validation report (when generated) | `evidence/playwright-validation-report.md` |

### Reverse proxy (code-adjacent)
Referenced from repo root: **`solution/pilot/reverse-proxy/`** (TLS/Caddy examples).

---

## Folder tree (high level)

```
planning/
  solution-build-master-steps.md    ← checklist hub
  README.md                         ← this index
  presentation/                     ← filled mock scenario + 3 use cases + mock-api JSON (step 15a)
  pilot-ops/                        ← Phase B runbooks + internal demo
  rfq-strategy/                     ← RFQ positioning / Arabic narrative
  phase-c/                          ← commercial & acceptance templates
  demos/draft-solution-demo/       ← Playwright demo package + PNGs
  evidence/                         ← validation reports
```
