import * as fs from "fs";
import * as path from "path";
import { expect, test } from "@playwright/test";

const root = path.join(__dirname, "..");
const outDir = path.join(root, "screenshots");
const BASE = "http://127.0.0.1:18001";

test.beforeAll(() => {
  fs.mkdirSync(outDir, { recursive: true });
});

test.describe("Live stack (skips if analytics not on :18001)", () => {
  test("10 live — Swagger /docs", async ({ page, request }) => {
    const ping = await request.get(`${BASE}/health`, {
      failOnStatusCode: false,
      timeout: 5000,
    });
    test.skip(
      !ping.ok(),
      "No analytics on 127.0.0.1:18001 — run solution/scripts/verify-local-stack.ps1"
    );
    await page.goto(`${BASE}/docs`, { waitUntil: "networkidle" });
    await expect(page).toHaveTitle(/bright info analytics|swagger ui/i);
    await page.screenshot({
      path: path.join(outDir, "10-live-swagger-docs.png"),
      fullPage: true,
    });
  });

  test("11 live — GET /health/db (JSON in browser)", async ({ page, request }) => {
    const ping = await request.get(`${BASE}/health`, { failOnStatusCode: false });
    test.skip(
      !ping.ok(),
      "No analytics on 127.0.0.1:18001"
    );
    await page.goto(`${BASE}/health/db`, { waitUntil: "domcontentloaded" });
    await expect(page.locator("body")).toContainText("db_connected");
    await page.screenshot({
      path: path.join(outDir, "11-live-health-db.png"),
      fullPage: true,
    });
  });

  test("12 live — OpenAPI JSON (routes visible)", async ({ page, request }) => {
    const ping = await request.get(`${BASE}/health`, { failOnStatusCode: false });
    test.skip(!ping.ok(), "No analytics on 127.0.0.1:18001");
    await page.goto(`${BASE}/openapi.json`, { waitUntil: "domcontentloaded" });
    await expect(page.locator("body")).toContainText("financial-bleed");
    await page.screenshot({
      path: path.join(outDir, "12-live-openapi-json.png"),
      fullPage: true,
    });
  });
});
