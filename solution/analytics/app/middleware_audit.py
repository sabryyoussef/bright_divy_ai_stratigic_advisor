"""Request audit logging for pilot compliance (no secrets, no request bodies)."""

from __future__ import annotations

import logging
import time
import uuid

from starlette.middleware.base import BaseHTTPMiddleware, RequestResponseEndpoint
from starlette.requests import Request
from starlette.responses import Response

logger = logging.getLogger("bright.analytics.audit")

_AUDIT_EXCLUDE_PREFIXES: tuple[str, ...] = ("/health",)


def _path_allowed_for_audit(path: str) -> bool:
    for prefix in _AUDIT_EXCLUDE_PREFIXES:
        if path == prefix or path.startswith(prefix + "/"):
            return False
    return True


class AuditLoggingMiddleware(BaseHTTPMiddleware):
    """Log method, path, status, duration, and client; emit X-Request-ID."""

    async def dispatch(self, request: Request, call_next: RequestResponseEndpoint) -> Response:
        request_id = str(uuid.uuid4())
        start = time.perf_counter()
        response = await call_next(request)
        duration_ms = (time.perf_counter() - start) * 1000.0
        client = request.client.host if request.client else None
        path = request.url.path
        if _path_allowed_for_audit(path):
            logger.info(
                "request_id=%s method=%s path=%s status=%s duration_ms=%.2f client=%s",
                request_id,
                request.method,
                path,
                response.status_code,
                duration_ms,
                client,
            )
        response.headers["X-Request-ID"] = request_id
        return response
