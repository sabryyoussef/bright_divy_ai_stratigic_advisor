# Local stack (warehouse + analytics + Ollama)

From `solution/`:

```powershell
docker compose -f docker-compose.yml -f stack/compose.stack.yml up -d --build --wait
```

Services:

| Service | Host port | Notes |
|---------|-----------|--------|
| `warehouse` | `55432` | Postgres (see root `docker-compose.yml`) |
| `analytics` | **`18001` → `8001`** | FastAPI: host `http://127.0.0.1:18001` (container listens on `8001`) |

Optional Ollama (Docker image is **large**; prefer Windows native Ollama for laptops):

```powershell
docker compose -f docker-compose.yml -f stack/compose.stack.yml -f stack/compose.ollama.yml up -d
```

Smoke test:

```powershell
powershell -ExecutionPolicy Bypass -File "..\scripts\verify-local-stack.ps1"
```

Pull a small model (Docker Ollama only):

```powershell
powershell -ExecutionPolicy Bypass -File "..\scripts\setup-ollama-model.ps1"
```

Or install **Windows Ollama** and run:

```powershell
powershell -ExecutionPolicy Bypass -File "..\scripts\setup-ollama-windows.ps1"
```
