# Dify (self-hosted) — wiring for this prototype

Official Dify Docker deployment changes frequently. This repo **does not vendor** the full upstream compose (it is large and versioned upstream).

## Step 8 — Run Dify (recommended path)

1. Clone upstream deployment assets (one-time):

```powershell
powershell -ExecutionPolicy Bypass -File "d:\bright_info\solution\scripts\bootstrap-dify.ps1"
```

2. Follow the generated instructions in:

- `d:\bright_info\solution\vendor\dify-docker\README.md` (path created by the bootstrap script)

3. Start Dify using **their** compose files, then ensure it can reach analytics:

- If Dify runs in Docker Desktop on Windows and analytics is reached via the **host-published** port (default **`18001`**):
  - Use `http://host.docker.internal:18001/...`
- If analytics runs in the same compose project network (`bright_*` services):
  - Use `http://analytics:8001/...`

## Local port note for this workstation

Port `8080` was occupied by another local service. Dify nginx is mapped to:

- `http://127.0.0.1:18080` (HTTP)
- `https://127.0.0.1:18443` (HTTPS)

This mapping is set in:
- `solution/vendor/dify-docker/docker/.env`

## Step 9 — Point Dify to Ollama (OpenAI-compatible)

Ollama exposes an OpenAI-compatible API at `http://<ollama-host>:11434/v1`.

In Dify model provider settings, set base URL to:

- `http://host.docker.internal:11434/v1` (Windows Docker Desktop ? host Ollama), or
- `http://ollama:11434/v1` (same compose stack as `stack/compose.stack.yml`)

## Step 10 — HTTP tool ? FastAPI

Create a **Custom Tool** (OpenAPI) or **HTTP Request** node pointing to:

- `POST http://host.docker.internal:18001/analytics/financial-bleed`
- JSON body: `{ "period": "2026-01" }`

See `dify/INTEGRATION.md` for copy/paste notes.

## Demo-ready setup assets

- Dify click-by-click setup: `planning/presentation/dify/dify-demo-setup.md`
- OpenAPI import file: `solution/dify/openapi/financial-bleed-tool.openapi.json`

## Step 11–13

- Prompts: `dify/prompts/system-ceo-advisor.md`
- Buttons: `dify/PHASE1_BUTTONS.md`
