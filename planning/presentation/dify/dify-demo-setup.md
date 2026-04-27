# Dify Demo Setup (agent-prepared)

This is the exact UI configuration to make the demo work with your running stack.

## Running endpoints (verified)

- Dify UI: `http://127.0.0.1:18080`
- Analytics API: `http://127.0.0.1:18001`
- Ollama OpenAI-compatible: `http://127.0.0.1:11434/v1`
- Ollama model: `qwen2.5:0.5b`

## 1) Model provider in Dify

1. Open Dify -> Settings -> Model Provider.
2. Add OpenAI-compatible provider (or Ollama provider if available):
   - Base URL: `http://host.docker.internal:11434/v1`
   - Model: `qwen2.5:0.5b`
   - API key: placeholder if required by UI.
3. Test prompt: `Reply with exactly model-ok`.

## 2) Create app

- App type: Chatbot
- Name: `CEO Strategic Advisor - Demo`

## 3) System prompt

Copy from: `solution/dify/prompts/system-ceo-advisor.md`

Critical lines:
- never invent numbers
- tool JSON is authoritative
- no recompute of KPI totals

## 4) Tool setup (recommended: OpenAPI import)

1. In the app, add Tool / HTTP capability.
2. Import file:
   - `solution/dify/openapi/financial-bleed-tool.openapi.json`
3. Ensure server URL stays:
   - `http://host.docker.internal:18001`
4. Test operation `getFinancialBleed` with:
   - `{ "period": "2026-01" }`

Expected:
- `net_qar = -15500`
- `bleed_detected = true`

## 5) Suggested workflow behavior

When user asks finance question:
1. Parse period (default ask follow-up if missing).
2. Call `getFinancialBleed`.
3. Answer with insight + up to 3 bullets, using only returned numbers.
4. If tool fails, explain data unavailable and ask user to retry.

## 6) Demo prompts to use live

English:
- `Did we have financial bleed in 2026-01 and what are top drivers?`
- `Compare 2026-02 versus 2026-01 using the same KPI definition.`

Arabic:
- `åá ßÇä áÏíäÇ äÒíÝ ãÇáí Ýí 2026-01 æãÇ Ãåã ãÓÈÈÇÊ ÇáÊßáÝÉ¿`
- `ÞÇÑä 2026-02 ãÚ 2026-01 ÈäÝÓ ÊÚÑíÝ ÇáãÄÔÑ.`

## 7) Expected numbers for presentation

From `solution/sample_data/financial_sample.csv`:
- 2026-01 -> revenue 50,000 / expense 65,500 / net -15,500
- 2026-02 -> revenue 63,000 / expense 45,000 / net +18,000

Reference scenario:
- `planning/presentation/full-demo-scenario.md`

## 8) Troubleshooting

- If Dify page shows wrong content at 8080: use `http://127.0.0.1:18080`.
- If tool call fails from Dify container: use `host.docker.internal` URL.
- If model call fails: verify `docker exec bright_ollama ollama list` includes `qwen2.5:0.5b`.
