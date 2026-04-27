/**
 * Single-page “draft solution” storyboard for Playwright screenshots (mock data).
 */
export function buildStoryboardHtml(params: {
  financialBleed: Record<string, unknown>;
  healthDb: Record<string, unknown>;
}): string {
  const { financialBleed, healthDb } = params;
  const fb = financialBleed as {
    period: string;
    revenue_qar: number;
    expense_qar: number;
    net_qar: number;
    bleed_detected: boolean;
    drivers: { category: string; impact_qar: number }[];
  };
  const rows = (fb.drivers || [])
    .map(
      (d) =>
        `<tr><td>${escapeHtml(
          d.category
        )}</td><td class="num">${d.impact_qar.toLocaleString("en-US")}</td></tr>`
    )
    .join("");

  return `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Draft — Strategic CEO Advisor (prototype)</title>
  <style>
    :root {
      --bg: #0f1419;
      --card: #1a2332;
      --border: #2d3a4d;
      --text: #e6edf3;
      --muted: #8b9cb3;
      --accent: #3b82f6;
      --ok: #22c55e;
      --warn: #f59e0b;
    }
    * { box-sizing: border-box; }
    body {
      font-family: "Segoe UI", system-ui, -apple-system, sans-serif;
      background: var(--bg);
      color: var(--text);
      margin: 0;
      min-height: 100vh;
      line-height: 1.5;
    }
    .wrap { max-width: 960px; margin: 0 auto; padding: 2.5rem 1.5rem 4rem; }
    .badge {
      display: inline-block;
      font-size: 0.75rem;
      text-transform: uppercase;
      letter-spacing: 0.08em;
      color: var(--accent);
      border: 1px solid var(--border);
      padding: 0.25rem 0.6rem;
      border-radius: 4px;
      margin-bottom: 0.75rem;
    }
    h1 { font-size: 1.75rem; font-weight: 700; margin: 0 0 0.5rem; }
    .sub { color: var(--muted); font-size: 0.95rem; margin-bottom: 2rem; }
    .grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1rem; margin-bottom: 1.5rem; }
    @media (max-width: 800px) { .grid { grid-template-columns: repeat(2, 1fr); } }
    .card {
      background: var(--card);
      border: 1px solid var(--border);
      border-radius: 8px;
      padding: 1rem 1.1rem;
    }
    .card label { display: block; font-size: 0.7rem; color: var(--muted); text-transform: uppercase; letter-spacing: 0.06em; }
    .num { font-size: 1.35rem; font-weight: 600; font-feature-settings: "tnum" 1; }
    .neg { color: #f87171; }
    h2 { font-size: 1.05rem; margin: 2rem 0 0.75rem; color: var(--muted); font-weight: 600; }
    table { width: 100%; border-collapse: collapse; font-size: 0.9rem; }
    th, td { text-align: left; padding: 0.5rem 0.75rem; border-bottom: 1px solid var(--border); }
    th { color: var(--muted); font-weight: 500; font-size: 0.75rem; text-transform: uppercase; }
    .flow {
      display: flex; flex-wrap: wrap; align-items: center; gap: 0.5rem 0.25rem;
      font-size: 0.85rem; color: var(--muted);
      background: var(--card); border: 1px solid var(--border);
      border-radius: 8px; padding: 1rem 1.25rem; margin-top: 0.5rem;
    }
    .flow b { color: var(--text); }
    .json {
      background: #0a0e14;
      border: 1px solid var(--border);
      border-radius: 8px; padding: 1rem; overflow: auto;
      font-size: 0.75rem; font-family: ui-monospace, Consolas, monospace;
      color: #a5d6ff;
      margin-top: 0.5rem;
    }
    .foot { margin-top: 2.5rem; font-size: 0.8rem; color: var(--muted); border-top: 1px solid var(--border); padding-top: 1rem; }
  </style>
</head>
<body>
  <div class="wrap">
    <div class="badge">Draft solution · ${escapeHtml(
      "mock data (presentation)"
    )}</div>
    <h1>Strategic CEO Advisor</h1>
    <p class="sub">Deterministic financial KPIs in <b>FastAPI + PostgreSQL</b>; conversation layer (e.g. Dify) uses tool JSON only—no LLM math for money.</p>

    <div class="flow">
      <b>CSV / Tally export</b> <span>→</span> <b>warehouse</b> <span>→</span> <b>POST /analytics/financial-bleed</b> <span>→</span> <b>UI + LLM wording</b>
    </div>

    <h2>Mock period: ${escapeHtml(fb.period)} (sample pipeline)</h2>
    <div class="grid">
      <div class="card">
        <label>Revenue (QAR)</label>
        <div class="num">${fb.revenue_qar.toLocaleString("en-US")}</div>
      </div>
      <div class="card">
        <label>Expense (QAR)</label>
        <div class="num">${fb.expense_qar.toLocaleString("en-US")}</div>
      </div>
      <div class="card">
        <label>Net (QAR)</label>
        <div class="num neg">${fb.net_qar.toLocaleString("en-US")}</div>
      </div>
      <div class="card">
        <label>Bleed flag</label>
        <div class="num" style="color:${
          fb.bleed_detected ? "var(--warn)" : "var(--ok)"
        }">${fb.bleed_detected ? "Yes" : "No"}</div>
      </div>
    </div>

    <h2>Top drivers (expense)</h2>
    <table>
      <thead><tr><th>Category</th><th>Impact (QAR)</th></tr></thead>
      <tbody>${rows}</tbody>
    </table>

    <h2>Data plane (mock /health/db)</h2>
    <div class="json">${escapeHtml(JSON.stringify(healthDb, null, 2))}</div>

    <h2>API tool response (excerpt JSON)</h2>
    <div class="json">${escapeHtml(
      JSON.stringify(financialBleed, null, 2)
    )}</div>

    <p class="foot">Generated for stakeholder preview. Run live stack + <code>npm run test:live</code> for real Swagger/health shots.</p>
  </div>
</body>
</html>`;
}

function escapeHtml(s: string): string {
  return s
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}
