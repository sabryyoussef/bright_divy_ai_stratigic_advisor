# Production / pilot deploy checklist (Step 32)

**Environment name:** [Pilot / Prod] | **Change window:** [date/time] | **Rollback owner:** [name]

## Pre-deploy

- [ ] **FSD** version tagged; **traceability** updated (`26-fsd-traceability-template.md`).  
- [ ] **UAT** exit criteria met or **waivers** documented (`30-uat-plan-template.md`).  
- [ ] **Security review** complete (`31-security-review-checklist.md`).  
- [ ] **Backup** taken (`planning/pilot-ops/postgres-backup-restore-runbook.md`).  
- [ ] **Secrets** injected in target env (not from Git).  
- [ ] **Docker / images** versions pinned; registry access OK.

## Deploy

- [ ] **Database** migrations or init applied.  
- [ ] **Analytics** service up; `/health` and `/health/db` green.  
- [ ] **Dify** (if in scope) reachable; tools point to correct **API base URL**.  
- [ ] **LLM** (Ollama) reachable from Dify per design.  
- [ ] **Reverse proxy / TLS** valid; DNS points to correct target.

## Post-deploy smoke

- [ ] `GET` health endpoints.  
- [ ] `POST` primary KPI tool with **known** period → **expected** numbers.  
- [ ] **Audit** log line appears for a non-health call (if enabled).

## Rollback

- [ ] Steps to restore DB from backup documented; last good **image tag** recorded.  
- [ ] Communication template to stakeholders if rollback: [link or N/A].

## Sign-off

| Role | Name | Date |
|------|------|------|
| Deploy lead | [ ] | [ ] |
| Client witness (if required) | [ ] | [ ] |
