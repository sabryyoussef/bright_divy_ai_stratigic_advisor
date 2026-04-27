import pytest
from fastapi.testclient import TestClient

from app.main import app


@pytest.fixture(scope="module")
def client(database_ready: bool) -> TestClient:
    if not database_ready:
        pytest.skip(
            "Warehouse not reachable or sample data missing. "
            "Run: docker compose up -d --wait (in solution/) then "
            "scripts/load-sample-financial-data.ps1"
        )
    return TestClient(app)


def test_financial_bleed_january_contract(client: TestClient) -> None:
    resp = client.post("/analytics/financial-bleed", json={"period": "2026-01"})
    assert resp.status_code == 200
    data = resp.json()
    assert data["status"] == "ok"
    assert data["period"] == "2026-01"
    assert data["revenue_qar"] == 50000.0
    assert data["expense_qar"] == 65500.0
    assert data["net_qar"] == -15500.0
    assert data["bleed_detected"] is True
    assert data["summary_key"] == "NEGATIVE_NET"
    assert data["drivers"][0]["category"] == "payroll"
    assert data["drivers"][0]["impact_qar"] == -62000.0


def test_financial_bleed_february_contract(client: TestClient) -> None:
    resp = client.post("/analytics/financial-bleed", json={"period": "2026-02"})
    assert resp.status_code == 200
    data = resp.json()
    assert data["net_qar"] == 18000.0
    assert data["bleed_detected"] is False
    assert data["summary_key"] == "POSITIVE_NET"


def test_financial_bleed_invalid_period(client: TestClient) -> None:
    resp = client.post("/analytics/financial-bleed", json={"period": "not-a-month"})
    assert resp.status_code == 422
