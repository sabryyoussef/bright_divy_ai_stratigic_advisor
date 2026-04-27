# PostgreSQL backup and restore (Step 20)

**Purpose:** Repeatable **pilot** backup/restore for the warehouse database (`warehouse`) without exposing PostgreSQL to the public internet. Adjust paths, retention, and credentials for the client environment.

**Assumption:** Database runs in Docker (e.g. `bright_warehouse`) as in `solution/docker-compose.yml`, port **55432** on the host.

## Backup (logical, `pg_dump`)

Run from the repo `solution` directory with the container **running**:

```powershell
cd d:\bright_info\solution
$ts = Get-Date -Format "yyyyMMdd_HHmmss"
$out = ".\backups\warehouse_${ts}.sql"
New-Item -ItemType Directory -Force -Path ".\backups" | Out-Null
docker compose exec -T warehouse pg_dump -U warehouse -d warehouse -F p -f - | Out-File -FilePath $out -Encoding utf8
Write-Host "Wrote $out"
```

**One-liner to container file then copy out:**

```powershell
docker compose exec -T warehouse sh -c "pg_dump -U warehouse -d warehouse -F c -f /tmp/warehouse.dump"
docker cp bright_warehouse:/tmp/warehouse.dump "d:\bright_info\solution\backups\warehouse.dump"
```

**Custom format (`.dump`)** is often preferred for `pg_restore` and large DBs. Plain SQL (first example) is easy to audit in Git if policy allows (usually backups stay **out** of Git).

## Restore (pilot / drill)

**Warning:** This overwrites the target database — use a **downtime** window or restore to a **new** database name for drills.

1. Stop writers (e.g. stop FastAPI, stop batch loads).
2. Restore custom format:

```powershell
cd d:\bright_info\solution
docker cp "d:\bright_info\solution\backups\warehouse.dump" bright_warehouse:/tmp/warehouse.dump
docker compose exec -T warehouse pg_restore -U warehouse -d warehouse --clean --if-exists -v /tmp/warehouse.dump
```

3. Re-run `verify-step1b` / `/health/db` and smoke tests.

For plain SQL:

```powershell
Get-Content .\backups\warehouse_YYYYMMDD_HHMMSS.sql -Raw | docker compose exec -T warehouse psql -U warehouse -d warehouse
```

## Retention and storage

- Keep **7 daily** + **4 weekly** minimum for pilot; store off-box (object storage, encrypted) per client policy.
- **Qatar / client residency:** keep backup **region** consistent with the deployment region.

## Restore drill (acceptance)

1. Note row count: `SELECT COUNT(*) FROM fact_transactions;`
2. Take backup, restore to a **separate** DB `warehouse_drill` (optional), or restore on a clone instance.
3. Compare checksums or row counts for critical tables.

## Related

- `pilot-network-architecture.md` (same folder — DB must stay private)
- `solution/docker-compose.yml`
