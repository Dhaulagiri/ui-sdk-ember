import { defineConfig } from "@playwright/test"

// Smoke tests for the docs site, run against its production build.
const port = process.env["SITE_PORT"] ?? "5341"

export default defineConfig({
  testDir: "tests/site",
  retries: process.env["CI"] ? 2 : 0,
  use: {
    baseURL: `http://localhost:${port}`,
    browserName: "chromium",
    trace: "retain-on-failure",
    channel: process.env.PLAYWRIGHT_CHANNEL,
  },
  webServer: {
    command: `pnpm --filter site build && SITE_PORT=${port} pnpm --filter site preview`,
    url: `http://localhost:${port}`,
    reuseExistingServer: !process.env["CI"],
    timeout: 180_000,
  },
})
