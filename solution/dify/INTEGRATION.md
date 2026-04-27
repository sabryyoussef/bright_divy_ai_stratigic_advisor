# Dify ↔ Analytics integration notes

## FastAPI endpoints (deterministic)

- `GET /health`
- `GET /health/db`
- `POST /analytics/financial-bleed` with JSON `{ "period": "YYYY-MM" }`

## Base URLs (pick one)

### A) Analytics on Docker Desktop (this repo stack)

If you started:

`docker compose -f docker-compose.yml -f stack/compose.stack.yml up ...`

Then from **another** Docker container on the default bridge (not the compose network), use the **published host port** (default **`18001`** in `stack/compose.stack.yml`; avoids Windows `127.0.0.1:8001` clashes):

- `http://host.docker.internal:18001`

From containers attached to the **same compose project network**, prefer the service DNS name:

- `http://analytics:8001`

### B) Analytics running on Windows host (uvicorn)

Use:

- `http://host.docker.internal:8001`

## Security note

Do not paste production secrets into Dify tool definitions. Prefer environment variables / Dify secret storage when available.
