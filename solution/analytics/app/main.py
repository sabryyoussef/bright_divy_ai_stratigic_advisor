import logging
from datetime import datetime, timezone

from fastapi import FastAPI
from fastapi.responses import JSONResponse
from pydantic import BaseModel, Field

from app.db import (
    check_db_connection,
    get_database_url,
    get_financial_bleed,
    redact_database_url,
)
from app.middleware_audit import AuditLoggingMiddleware

logging.getLogger("bright.analytics.audit").setLevel(logging.INFO)

app = FastAPI(
    title="Bright Info Analytics Service",
    version="0.1.0",
    description="Deterministic analytics API for business KPIs.",
)

app.add_middleware(AuditLoggingMiddleware)


class FinancialBleedRequest(BaseModel):
    period: str = Field(..., pattern=r"^\d{4}-\d{2}$")


@app.get("/health")
def health() -> dict:
    """Basic health check for service startup and monitoring."""
    return {
        "status": "ok",
        "service": "analytics",
        "database_url": redact_database_url(get_database_url()),
        "timestamp_utc": datetime.now(timezone.utc).isoformat(),
    }


@app.get("/health/db")
def health_db() -> JSONResponse:
    """Validate the configured DATABASE_URL can query warehouse data."""
    try:
        db_probe = check_db_connection()
        return JSONResponse(
            status_code=200,
            content={
                "status": "ok",
                "service": "analytics",
                "db_connected": True,
                **db_probe,
                "timestamp_utc": datetime.now(timezone.utc).isoformat(),
            },
        )
    except Exception as exc:  # pragma: no cover - operational path
        return JSONResponse(
            status_code=503,
            content={
                "status": "error",
                "service": "analytics",
                "db_connected": False,
                "database_url": redact_database_url(get_database_url()),
                "error": str(exc),
                "timestamp_utc": datetime.now(timezone.utc).isoformat(),
            },
        )


@app.post("/analytics/financial-bleed")
def financial_bleed(payload: FinancialBleedRequest) -> JSONResponse:
    """Deterministic financial bleed endpoint (no LLM math)."""
    try:
        result = get_financial_bleed(payload.period)
        return JSONResponse(
            status_code=200,
            content={
                "status": "ok",
                "service": "analytics",
                **result,
                "timestamp_utc": datetime.now(timezone.utc).isoformat(),
            },
        )
    except Exception as exc:  # pragma: no cover - operational path
        return JSONResponse(
            status_code=500,
            content={
                "status": "error",
                "service": "analytics",
                "database_url": redact_database_url(get_database_url()),
                "error": str(exc),
                "timestamp_utc": datetime.now(timezone.utc).isoformat(),
            },
        )
