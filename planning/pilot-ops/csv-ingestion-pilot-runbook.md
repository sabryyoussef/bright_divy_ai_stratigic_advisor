# CSV ingestion runbook — pilot (Step 21)

**Purpose:** Weekly/daily (as agreed) path from **Tally export** → **validation** → **load** into the warehouse, aligned with Phase 1 scope (CSV acceptable for pilot).

**Not in scope for this doc:** direct Tally API or automated scheduler — see optional Step 22 (n8n) in the master plan.

## Roles

| Role | Action |
|------|--------|
| Finance / ops | Export CSV from Tally on agreed schedule; place file in agreed secure folder |
| Integrator | Run validation + load; confirm row counts and `/health/db` |
| System | `fact_transactions` and related tables only — schema in `solution/sql/` |

## Preconditions

- Warehouse running (`docker compose up` or client-managed Postgres with same schema).
- File encoding **UTF-8**; columns compatible with `COPY` target (see `load-sample-financial-data.ps1` and `001_init_warehouse.sql`).

## Path A — sample pipeline (dev parity)

The repo provides a full example loader:

1. `d:\bright_info\solution\sample_data\financial_sample.csv`
2. `d:\bright_info\solution\scripts\load-sample-financial-data.ps1`

**Run:**

```powershell
cd d:\bright_info\solution
powershell -ExecutionPolicy Bypass -File .\scripts\load-sample-financial-data.ps1
```

3. Verify: `GET` analytics `http://127.0.0.1:18001/health/db` (expect `fact_transactions_rows` > 0) or SQL `SELECT COUNT(*) FROM fact_transactions WHERE source_system = 'csv_finance_sample';`

## Path B — production pilot export

1. **Export** from Tally to CSV per **FSD** column spec (to be provided after NDA) — not assumed here.
2. **Stage** the file in a **non-Git** directory (e.g. `D:\pilot\exports\incoming\`).
3. **Validate** (manual or script):
   - Row count, required columns, date range, no duplicate batch ID if you add one.
   - Spot-check amounts vs source.
4. **Map** to `fact_transactions` column order; use a staging table if transforms are needed.
5. **Load** with `COPY` (same pattern as the sample script) or bulk insert from reviewed staging.
6. **Verify**:
   - SQL counts and `POST /analytics/financial-bleed` for a known test period.
7. **Log** in change record: who loaded, when, file name, hash (SHA-256) of file.

## Failure handling

- If load fails mid-batch: use a transaction per batch when using SQL scripts; with `COPY` on full file, restore from backup (see `postgres-backup-restore-runbook.md` in this folder) or delete by `source_system` / batch id if designed.

## Related

- `solution/scripts/load-sample-financial-data.ps1`
- `planning/solution-build-master-steps.md` Step **22** (optional n8n)
