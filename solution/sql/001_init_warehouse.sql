-- Step 1: business warehouse schema (pilot / prototype)
-- Loaded automatically on first container init only.

CREATE TABLE IF NOT EXISTS dim_date (
    date_key DATE PRIMARY KEY,
    year INT NOT NULL,
    month INT NOT NULL,
    day INT NOT NULL
);

CREATE TABLE IF NOT EXISTS fact_transactions (
    id BIGSERIAL PRIMARY KEY,
    txn_date DATE NOT NULL,
    account_type TEXT NOT NULL CHECK (account_type IN ('revenue', 'expense')),
    amount_qar NUMERIC(18, 2) NOT NULL,
    category TEXT NOT NULL,
    source_system TEXT DEFAULT 'csv_import',
    imported_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_fact_transactions_date ON fact_transactions (txn_date);
CREATE INDEX IF NOT EXISTS idx_fact_transactions_type ON fact_transactions (account_type);
