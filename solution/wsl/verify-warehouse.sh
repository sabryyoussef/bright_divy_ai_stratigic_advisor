#!/usr/bin/env bash
# Quick check after bootstrap (needs sudo for postgres user).
set -euo pipefail
sudo -u postgres psql -d warehouse -c "\dt"
sudo -u postgres psql -d warehouse -c "SELECT COUNT(*) AS fact_rows FROM fact_transactions;"
