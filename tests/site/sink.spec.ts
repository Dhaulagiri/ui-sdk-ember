import { readdirSync, readFileSync } from "node:fs"
import { expect, test, type Page } from "@playwright/test"

// Every tile the port defines, read from its files, so a file that stops
// loading shows up as missing tiles.
const tileDir = "examples/sink/tiles"
const tileIds = readdirSync(tileDir)
  .filter((file) => file.endsWith(".gts"))
  .flatMap((file) =>
    [
      ...readFileSync(`${tileDir}/${file}`, "utf8").matchAll(
        /^\s+id: "((?:reference|forms|overlays|collections|motion|language|drag|studio)-[\w-]+)",$/gm
      ),
    ].map(([, id]) => id!)
  )

function collectErrors(page: Page) {
  const errors: string[] = []
  page.on("pageerror", (error) => errors.push(error.message))
  page.on("console", (message) => {
    if (message.type() === "error") {
      errors.push(message.text())
    }
  })
  return errors
}

test("every sink tile renders without errors", async ({ page }) => {
  const errors = collectErrors(page)
  await page.goto("/#/sink")
  await expect(page.locator(".tile")).toHaveCount(tileIds.length)
  for (const id of tileIds) {
    await expect(
      page.locator(`#${id} .tile-stage > *`).first(),
      `${id} renders its demo`
    ).toBeAttached()
  }
  // Timers and observers in the tiles get a moment to run.
  await page.waitForTimeout(1_000)
  expect(errors).toEqual([])
})

test("a tile's tag filters the grid and the bar clears it", async ({
  page,
}) => {
  const errors = collectErrors(page)
  await page.goto("/#/sink")
  const volume = page.locator("#reference-volume")
  await volume.getByRole("button", { name: "Slider" }).click()
  await expect(page).toHaveURL(/[?&]uses=Slider/)
  await expect(volume).toBeVisible()
  await expect(page.locator("#reference-switches")).toBeHidden()
  const filters = page.getByRole("region", { name: "Filters" })
  await filters.getByRole("button", { name: "Clear filters" }).click()
  await expect(page.locator("#reference-switches")).toBeVisible()
  await expect(page).not.toHaveURL(/uses=/)
  expect(errors).toEqual([])
})

test("the sink fits a phone without sideways scroll", async ({ page }) => {
  await page.setViewportSize({ width: 375, height: 812 })
  await page.goto("/#/sink")
  await expect(page.locator(".tile").first()).toBeVisible()
  const overflow = await page.evaluate(
    () => document.documentElement.scrollWidth - window.innerWidth
  )
  expect(overflow).toBeLessThanOrEqual(0)
})

test("the agent panel drives tiles and waits for the person on a marked step", async ({
  page,
}) => {
  const errors = collectErrors(page)
  await page.goto("/#/sink")
  await page.getByRole("button", { name: "Agent", exact: true }).click()
  const panel = page.getByRole("complementary", { name: "Agent" })

  await panel.getByRole("button", { name: /Quiet my devices down/ }).click()
  await expect(panel.locator(".agent-log")).toContainText(
    "Wi-Fi and Bluetooth are off",
    { timeout: 10_000 }
  )
  await expect(page.getByRole("switch", { name: /Wi-Fi/ })).not.toBeChecked()

  await panel.getByRole("button", { name: /Delete the legacy-cron/ }).click()
  const ask = page.getByRole("alertdialog", { name: "Let the agent do this?" })
  await expect(ask).toContainText("Delete legacy-cron and its 12 deployments", {
    timeout: 10_000,
  })
  await ask.getByRole("button", { name: "Refuse" }).click()
  await expect(panel.locator(".agent-log")).toContainText("You refused")

  await panel.getByRole("tab", { name: "Activity" }).click()
  await expect(panel.locator(".agent-changes")).toContainText("Volume")
  expect(errors).toEqual([])
})

test("the agent sees the tiles, not the tags or its own panel", async ({
  page,
}) => {
  await page.goto("/#/sink")
  await expect(page.locator(".tile").first()).toBeVisible()
  const components = await page.evaluate(() =>
    (
      window as unknown as {
        agent: { snapshot: () => { component: string; label?: string }[] }
      }
    ).agent.snapshot()
  )
  const labels = components.map((c) => `${c.component}:${c.label ?? ""}`)
  expect(labels).toContain("radio:Cabin")
  expect(labels.filter((label) => label.startsWith("toggle:Slider"))).toEqual(
    []
  )
  expect(labels.some((label) => label.includes("Tool"))).toBe(false)
})
