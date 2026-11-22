import { expect, test } from "@playwright/test"

test("the A2UI page draws one stream with both catalogs, and an agent fills the ui-sdk one", async ({
  page,
}) => {
  const errors: string[] = []
  page.on("pageerror", (error) => errors.push(error.message))
  page.on("console", (message) => {
    if (message.type() === "error") {
      errors.push(message.text())
    }
  })
  await page.goto("/#/a2ui")
  const basic = page.locator(".a2-surface").first()
  const uiSdk = page.locator(".a2-uisdk")
  await expect(basic.getByText("Plan a trip")).toBeVisible()
  await expect(uiSdk.getByText("Plan a trip")).toBeVisible()
  await expect(uiSdk.getByRole("radio", { name: "Economy" })).toBeChecked()

  // A person's change writes the same data model the basic catalog uses.
  await uiSdk.getByRole("textbox", { name: "Traveler" }).fill("Grace Hopper")
  await expect(page.locator(".a2-model pre").last()).toContainText(
    '"name": "Grace Hopper"'
  )

  await page.getByRole("button", { name: "What can an agent see?" }).click()
  await expect(page.locator(".a2-seen")).toContainText(
    "finds 0 components in the basic catalog's surface"
  )

  await page
    .getByRole("button", { name: "Let the agent fill the rest" })
    .click()
  const log = page.getByRole("list", { name: "Agent log" })
  await expect(log).toContainText("Pressed Find trips", { timeout: 15_000 })
  await expect(log).toContainText('Traveler is "Grace Hopper", kept')
  await expect(uiSdk).toContainText("Found 3 trips to Lisbon for Grace Hopper")
  await expect(
    uiSdk.getByRole("checkbox", { name: "Seat selection" })
  ).toBeChecked()
  expect(errors).toEqual([])
})

test("the A2UI page fits a phone without sideways scroll", async ({ page }) => {
  await page.setViewportSize({ width: 375, height: 812 })
  await page.goto("/#/a2ui")
  await expect(page.locator(".a2-uisdk").getByText("Plan a trip")).toBeVisible()
  const overflow = await page.evaluate(
    () => document.documentElement.scrollWidth - window.innerWidth
  )
  expect(overflow).toBeLessThanOrEqual(0)
})
