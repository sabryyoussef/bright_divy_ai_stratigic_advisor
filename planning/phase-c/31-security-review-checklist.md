# Security review checklist (Step 31)

**Purpose:** Pre–go-live review for pilot/prod. Align with client security and `planning/pilot-ops/pilot-network-architecture.md`. Not a certification.

## Access & identity

- [ ] **RBAC** implemented as per `planning/pilot-ops/pilot-rbac-design.md` (design) and FSD (what was built).  
- [ ] **Least privilege** DB user for application; no shared admin password with Dify.  
- [ ] **Admin** access to Dify / host **MFA** where available.

## Network

- [ ] **Database** not on public internet; SG / firewall rules documented.  
- [ ] **TLS** for user-facing endpoints (`planning/phase-c` Step 17 pattern or equivalent).  
- [ ] **Secrets** not in Git; rotation process known.

## Data

- [ ] **Encryption in transit** for user → app; app → DB as applicable.  
- [ ] **Backups** configured; restore **tested** once (`planning/pilot-ops/postgres-backup-restore-runbook.md`).  
- [ ] **Data residency** documented (where data and backups live).

## Logging & audit

- [ ] **Audit** / request logging for API (no secrets; `X-Request-ID` trace).  
- [ ] **Log retention** and access policy agreed (who can read production logs).

## Application

- [ ] **Dependency** scan or update plan (Python, containers).  
- [ ] **Rate limiting** / abuse notes for public entry (if any).  
- [ ] **LLM**: no business numbers invented; tool JSON is source of truth.

## Compliance mapping (informational)

- [ ] **PDPPL (Qatar)** — data categories, legal basis / client instruction, subprocessors list.  
- [ ] **NCSA AI** — governance, human oversight for high-risk decisions (as applicable).  
- [ ] Client **internal** policy sign-off if required.

## Sign-off

| Role | Name | Date |
|------|------|------|
| Technical lead | [ ] | [ ] |
| Client security / IT (if required) | [ ] | [ ] |
