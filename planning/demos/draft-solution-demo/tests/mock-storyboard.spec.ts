import * as fs from "fs";
import * as path from "path";
import { test } from "@playwright/test";
import { buildStoryboardHtml } from "../lib/build-storyboard-html";

const root = path.join(__dirname, "..");
const outDir = path.join(root, "screenshots");

test.beforeAll(() => {
  fs.mkdirSync(outDir, { recursive: true });
});

function loadMocks() {
  const financialBleed = JSON.parse(
    fs.readFileSync(
      path.join(root, "mock", "financial-bleed-2026-01.json"),
      "utf-8"
    )
  ) as Record<string, unknown>;
  const healthDb = JSON.parse(
    fs.readFileSync(path.join(root, "mock", "health-db.json"), "utf-8")
  ) as Record<string, unknown>;
  return { financialBleed, healthDb };
}

test("01 mock storyboard — desktop (draft KPI + JSON)", async ({ page }) => {
  const { financialBleed, healthDb } = loadMocks();
  const html = buildStoryboardHtml({ financialBleed, healthDb });
  await page.setViewportSize({ width: 1280, height: 800 });
  await page.setContent(html, { waitUntil: "domcontentloaded" });
  await page.screenshot({
    path: path.join(outDir, "01-mock-storyboard-desktop.png"),
    fullPage: true,
  });
});

test("02 mock storyboard — mobile width", async ({ page }) => {
  const { financialBleed, healthDb } = loadMocks();
  const html = buildStoryboardHtml({ financialBleed, healthDb });
  await page.setViewportSize({ width: 390, height: 844 });
  await page.setContent(html, { waitUntil: "domcontentloaded" });
  await page.screenshot({
    path: path.join(outDir, "02-mock-storyboard-mobile.png"),
    fullPage: true,
  });
});
