const assert = require("node:assert/strict")
const { realpathSync } = require("node:fs")
const { test } = require("node:test")
const Project = require("ember-cli/lib/models/project")

test("Ember CLI discovers the packed addon without a missing main error", () => {
  const installed = require.resolve("ember-ui-sdk/package.json")
  assert.ok(
    realpathSync(installed).includes("/test-app/node_modules/ember-ui-sdk/")
  )
  const project = Project.closestSync(process.cwd())
  project.initializeAddons()
  assert.ok(project.addons.some((addon) => addon.name === "ember-ui-sdk"))
})
