import os
from typing import Any
from urllib.parse import urlparse, urlunparse

import psycopg

DEFAULT_DATABASE_URL = (
    "postgresql://warehouse:warehouse_dev_change_me@127.0.0.1:55432/warehouse"
)


def get_database_url() -> str:
    """Return DATABASE_URL from environment, or local Docker default."""
    return os.getenv("DATABASE_URL", DEFAULT_DATABASE_URL)


def redact_database_url(url: str) -> str:
    """Hide password in a postgres URL for client-facing responses."""
    try:
        parsed = urlparse(url)
        if not parsed.password:
            return url
        host = parsed.hostname or ""
        port = f":{parsed.port}" if parsed.port else ""
        user = parsed.username or ""
        netloc = f"{user}:***@{host}{port}"
        return urlunparse(
            (parsed.scheme, netloc, parsed.path, "", parsed.query, parsed.fragment)
        )
    except Exception:  # pragma: no cover - defensive
        return "postgresql://***"


def check_db_connection() -> dict[str, Any]:
    """Run a tiny deterministic DB probe."""
    database_url = get_database_url()
    with psycopg.connect(database_url) as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT current_database(), COUNT(*) FROM fact_transactions;")
            db_name, fact_rows = cur.fetchone()
    return {
        "database_url": redact_database_url(database_url),
        "database": db_name,
        "fact_transactions_rows": int(fact_rows),
    }


def get_financial_bleed(period: str) -> dict[str, Any]:
    """Compute deterministic financial bleed metrics for a YYYY-MM period."""
    database_url = get_database_url()
    with psycopg.connect(database_url) as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT
                    COALESCE(SUM(CASE WHEN account_type = 'revenue' THEN amount_qar END), 0),
                    COALESCE(SUM(CASE WHEN account_type = 'expense' THEN amount_qar END), 0),
                    COALESCE(SUM(CASE WHEN account_type = 'revenue' THEN amount_qar ELSE -amount_qar END), 0)
                FROM fact_transactions
                WHERE to_char(txn_date, 'YYYY-MM') = %s;
                """,
                (period,),
            )
            revenue_qar, expense_qar, net_qar = cur.fetchone()

            cur.execute(
                """
                SELECT
                    category,
                    SUM(amount_qar) AS expense_qar
                FROM fact_transactions
                WHERE to_char(txn_date, 'YYYY-MM') = %s
                  AND account_type = 'expense'
                GROUP BY category
                ORDER BY expense_qar DESC
                LIMIT 3;
                """,
                (period,),
            )
            drivers = [
                {"category": row[0], "impact_qar": -float(row[1])}
                for row in cur.fetchall()
            ]

    net_value = float(net_qar)
    return {
        "period": period,
        "revenue_qar": float(revenue_qar),
        "expense_qar": float(expense_qar),
        "net_qar": net_value,
        "bleed_detected": net_value < 0,
        "summary_key": "NEGATIVE_NET" if net_value < 0 else "POSITIVE_NET",
        "drivers": drivers,
        "database_url": redact_database_url(database_url),
    }
