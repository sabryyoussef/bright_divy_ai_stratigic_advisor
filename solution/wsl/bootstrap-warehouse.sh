#!/usr/bin/env bash
# One-time setup: create DB + role + tables (same as Docker init SQL).
# Run inside Ubuntu WSL from repo:
#   cd /mnt/d/bright_info/solution/wsl && bash bootstrap-warehouse.sh
# You will be prompted for sudo (postgres superuser).

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOLUTION_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SQL_INIT="$SOLUTION_DIR/sql/001_init_warehouse.sql"

if [[ ! -f "$SQL_INIT" ]]; then
  echo "Missing $SQL_INIT"
  exit 1
fi

echo "== Creating role and database (idempotent) =="
# Quoted heredoc so bash does not expand $$ to PID.
sudo -u postgres psql -v ON_ERROR_STOP=1 -d postgres <<'EOSQL'
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'warehouse') THEN
    CREATE ROLE warehouse LOGIN PASSWORD 'warehouse_dev_change_me';
  END IF;
END $$;

SELECT 'CREATE DATABASE warehouse OWNER warehouse'
WHERE NOT EXISTS (SELECT 1 FROM pg_database WHERE datname = 'warehouse')
\gexec
EOSQL

echo "== Applying schema =="
sudo -u postgres psql -v ON_ERROR_STOP=1 -d warehouse -f "$SQL_INIT"

echo "== Grants for app user (warehouse) =="
sudo -u postgres psql -v ON_ERROR_STOP=1 -d warehouse <<'EOSQL'
GRANT CONNECT ON DATABASE warehouse TO warehouse;
GRANT USAGE ON SCHEMA public TO warehouse;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO warehouse;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO warehouse;
EOSQL

echo "== Tables =="
sudo -u postgres psql -d warehouse -c "\dt"

echo ""
echo "From Windows, use: postgresql://warehouse:warehouse_dev_change_me@127.0.0.1:5432/warehouse"
echo "(WSL2 forwards localhost:5432 to this Postgres when the service listens on 0.0.0.0.)"
