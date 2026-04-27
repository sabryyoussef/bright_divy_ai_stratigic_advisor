# Reverse proxy + TLS (Step 17)

**Purpose:** Put **Caddy** (or nginx) in front of **Dify** and the **FastAPI** analytics service for HTTPS, one hostname, and sane defaults for a pilot.

**Status:** Example configuration only — adapt hostnames, ports, and cert paths to your deployment. Not wired into the default `docker compose` in `solution/`.

## Layout

- **Caddy** listens on `443` (TLS) and routes:
  - `dify.pilot.example.com` → Dify origin (e.g. `127.0.0.1:80` or container port on bridge).
  - `api.pilot.example.com` → FastAPI (e.g. `127.0.0.1:18001` if using the stack host port from `stack/compose.stack.yml`).

Use **separate** origins if Dify and FastAPI run on different hosts/ports; merge into one file or split Caddy `import`.

## Local / pilot TLS

- **Public DNS + Let’s Encrypt:** Caddy can obtain certificates automatically if ports 80/443 are reachable and DNS points to the host.
- **Private pilot:** Use an internal CA, or `tls self_signed` for demos only, or client VPN to reach private IPs and terminate TLS on the proxy.

## Files

- `Caddyfile.example` — copy to `Caddyfile`, replace domains and `reverse_proxy` targets.

## Health checks

- After deployment: `https://api.pilot.example.com/health` and `https://api.pilot.example.com/health/db` (with DB up).

## See also

- `planning/pilot-ops/pilot-network-architecture.md`
