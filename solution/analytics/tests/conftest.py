import os

import pytest


def pytest_configure() -> None:
    """Default local Docker warehouse URL for contract tests (host -> mapped port)."""
    os.environ.setdefault(
        "DATABASE_URL",
        "postgresql://warehouse:warehouse_dev_change_me@127.0.0.1:55432/warehouse",
    )


@pytest.fixture(scope="session")
def database_ready() -> bool:
    """True if warehouse accepts connections and has sample rows."""
    try:
        import psycopg

        url = os.environ["DATABASE_URL"]
        with psycopg.connect(url, connect_timeout=3) as conn:
            with conn.cursor() as cur:
                cur.execute(
                    "SELECT COUNT(*) FROM fact_transactions WHERE source_system = %s;",
                    ("csv_finance_sample",),
                )
                (n,) = cur.fetchone()
        return int(n) > 0
    except Exception:
        return False
