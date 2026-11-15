import { readdirSync, readFileSync } from "node:fs"
import { defineConfig } from "@playwright/test"

// Runs ui-sdk's own behavior specs, unchanged, against the Ember fixtures in
// playground. vendor/ui is pinned to the @ui-sdk/core release we depend on.
const port = process.env["PLAYGROUND_PORT"] ?? "5340"
const specRoot = "vendor/ui/tests/specs"

// Specs that fail for a reason that isn't a bug, by title, each with why.
const knownGaps: Record<string, string> = {}

const fixtures = new Set(
  readdirSync("playground/src/fixtures").flatMap((name) =>
    readdirSync(`playground/src/fixtures/${name}`)
      .filter((file) => /^ember.*\.ts$/.test(file))
      .map((file) => `${name}:${file.replace(/\.ts$/, "")}`)
  )
)

const hasFixture = (name: string, framework: string) =>
  fixtures.has(`${name}:${framework}`)

const specFiles = readdirSync(specRoot).filter(
  (file) =>
    file.endsWith(".spec.ts") &&
    !/\.(kitchen-sink|counts|ssr)\.spec\.ts$/.test(file)
)

const specsFor = (framework: string) =>
  specFiles.filter((file) => {
    const opened = [
      ...readFileSync(`${specRoot}/${file}`, "utf8").matchAll(
        /\bopen\(\s*"([\w-]+)"/g
      ),
    ].map(([, fixture]) => fixture!)
    return !opened.length || opened.some((name) => hasFixture(name, framework))
  })

const escape = (text: string) => text.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")
const filesMatching = (files: string[]) =>
  files.map((file) => new RegExp(`/${escape(file)}$`))

export default defineConfig<{
  framework: string
  fixtureOptions: Record<string, string>
}>({
  testDir: specRoot,
  grepInvert: Object.keys(knownGaps).length
    ? new RegExp(Object.keys(knownGaps).map(escape).join("|"))
    : undefined,
  fullyParallel: true,
  retries: process.env["CI"] ? 2 : 0,
  use: { baseURL: `http://localhost:${port}`, trace: "retain-on-failure" },
  webServer: {
    command: `PLAYGROUND_PORT=${port} pnpm --filter playground dev`,
    url: `http://localhost:${port}`,
    reuseExistingServer: !process.env["CI"],
    timeout: 120_000,
  },
  projects: [
    ...["ember", "ember-data"].map((framework) => ({
      name: framework,
      use: { browserName: "chromium" as const, framework },
      testMatch: filesMatching(specsFor(framework)),
    })),
  ],
})
