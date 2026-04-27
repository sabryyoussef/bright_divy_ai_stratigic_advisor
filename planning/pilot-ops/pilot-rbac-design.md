# RBAC and credential separation (Step 18)

**Purpose:** Define roles, permissions, and **separate credentials** for pilot operations — aligned with RFQ (CEO vs read-only, audit, no shared super-user across layers).

## Principles

1. **Least privilege** — each component gets only the DB and HTTP access it needs.
2. **No shared “admin” password** across PostgreSQL, Dify admin, and host OS.
3. **Dify does not own business truth** — numeric KPIs and warehouse tables are authoritative; Dify is orchestration and wording.

## Suggested roles (application)

| Role | Dify / UI | Analytics API | Notes |
|------|-----------|---------------|--------|
| **CEO** | Use chat, trigger Phase-1 **confirmation-only** buttons | All read/analytics routes allowed | Optional future: scope by org/tenant if multi-tenant |
| **Read-only** | View conversations, no destructive admin | Same as CEO for pilot or GET-only if split later | Good for board secretary / finance reviewer |
| **Admin** | Dify workspace settings, user invites | N/A (API admin is separate) | Minimize; use break-glass account |
| **Integrator** | Not typical for CEO product | N/A | DevOps: deploy, rotate secrets, backup |

**Implementation path:**

- **Dify:** use built-in user/workspace roles and restrict “dangerous” tools to server-side only (Phase-1 buttons are UI-confirmation only; see `solution/dify/PHASE1_BUTTONS.md`).
- **FastAPI:** add API keys or OIDC in a later iteration; for pilot, pair **private network** + **reverse proxy auth** (basic auth, OAuth2 proxy) or mTLS for internal-only URL.

## Credential separation

| Store / system | Account purpose | Must not |
|----------------|------------------|----------|
| **PostgreSQL** | `warehouse_app` — DML for warehouse + `fact_transactions` as designed | Reuse for OS login or Dify |
| **Dify** | Admin for app config; normal users for chat | Reuse for DB `postgres` superuser |
| **Host / VM** | SSH or RDP for operations | Same password as any DB or Dify admin |

**PoC today:** `docker-compose` uses `warehouse` + password from env — rotate for any shared environment and override via `DATABASE_URL` (see `solution/.env.example`).

## Future API-level RBAC (optional)

- Validate JWT (OIDC) on FastAPI; map `sub` + groups → route allow list.
- Log **subject id** in audit (see `app/middleware_audit.py`) when auth is present.

## Related

- `pilot-network-architecture.md` (same folder)
- `postgres-backup-restore-runbook.md` (same folder; access control to backup storage)
