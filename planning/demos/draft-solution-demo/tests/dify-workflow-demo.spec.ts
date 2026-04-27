import * as fs from "fs";
import * as path from "path";
import { expect, test } from "@playwright/test";

const outDir = path.resolve(process.cwd(), "screenshots", "dify-workflow");
const difyBase = process.env.DIFY_BASE_URL || "http://127.0.0.1:18080";
const difyEmail = process.env.DIFY_EMAIL;
const difyPassword = process.env.DIFY_PASSWORD;
const appName = process.env.DIFY_APP_NAME || "CEO Strategic Advisor - Demo Agent";

test.beforeAll(() => {
  fs.mkdirSync(outDir, { recursive: true });
});

test("dify workflow demo capture", async ({ page }) => {
  test.setTimeout(120000);
  test.skip(!difyEmail || !difyPassword, "Missing DIFY_EMAIL / DIFY_PASSWORD");

  await page.setViewportSize({ width: 1440, height: 900 });

  // 1) Sign in.
  await page.goto(`${difyBase}/signin`, { waitUntil: "domcontentloaded" });
  await page.getByLabel(/email address/i).fill(difyEmail!);
  await page.getByLabel(/password/i).fill(difyPassword!);
  await page.screenshot({
    path: path.join(outDir, "20-dify-signin-filled.png"),
    fullPage: true,
  });

  await Promise.all([
    page.waitForURL(/\/apps/, { timeout: 30000 }),
    page.getByRole("button", { name: /^sign in$|^login$/i }).click(),
  ]);
  await page.screenshot({
    path: path.join(outDir, "21-dify-apps-home.png"),
    fullPage: true,
  });

  // 2) Open the agent app card.
  await page.getByText(appName, { exact: false }).first().click();
  await page.waitForTimeout(2500);
  await page.screenshot({
    path: path.join(outDir, "22-dify-agent-open.png"),
    fullPage: true,
  });

  // 3) Attempt to enter preview/debug and run a prompt.
  const runButton = page.getByRole("button", { name: /debug|preview|run|chat/i }).first();
  if (await runButton.isVisible().catch(() => false)) {
    await runButton.click();
    await page.waitForTimeout(1500);
  }

  // Try common input selectors; continue even if none exists.
  const prompt = "Did we have financial bleed in 2026-01 and what are top drivers?";
  const inputCandidates = [
    'textarea',
    'input[placeholder*="message" i]',
    'input[placeholder*="ask" i]',
    '[contenteditable="true"]',
  ];
  let submitted = false;
  for (const sel of inputCandidates) {
    const locator = page.locator(sel).first();
    if (await locator.isVisible().catch(() => false)) {
      await locator.click();
      await locator.fill(prompt).catch(async () => {
        await locator.pressSequentially(prompt);
      });
      await page.keyboard.press("Enter");
      submitted = true;
      break;
    }
  }

  await page.waitForTimeout(5000);
  await page.screenshot({
    path: path.join(outDir, "23-dify-workflow-run.png"),
    fullPage: true,
  });

  // Keep a light assertion so failures are meaningful.
  await expect(page.locator("body")).toContainText(/apps|agent|workflow|chat/i);
  // Some Dify builds render chat input in nested components; keep the run capture non-flaky.
  if (!submitted) {
    console.warn("Prompt was not submitted because no input selector was visible.");
  }
});

