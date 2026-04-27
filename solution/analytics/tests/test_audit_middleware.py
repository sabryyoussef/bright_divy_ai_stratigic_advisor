from fastapi.testclient import TestClient

from app.main import app


def test_x_request_id_header_on_openapi() -> None:
    client = TestClient(app)
    resp = client.get("/openapi.json")
    assert resp.status_code == 200
    xrid = resp.headers.get("x-request-id") or resp.headers.get("X-Request-ID")
    assert xrid and len(xrid) == 36
