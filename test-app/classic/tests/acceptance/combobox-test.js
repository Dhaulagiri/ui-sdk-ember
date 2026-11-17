import { module, test } from "qunit"
import { setupApplicationTest } from "ember-qunit"
import { click, findAll, visit, waitUntil } from "@ember/test-helpers"

module("Acceptance | classic packed combobox", function (hooks) {
  setupApplicationTest(hooks)

  test("the classic application boots with a contextual combobox", async function (assert) {
    await visit("/")
    assert.dom('[role="combobox"]').exists()
    await click('[data-slot="combobox-trigger"]')
    await waitUntil(() => document.querySelector('[role="listbox"]'))
    await click(findAll('[role="option"]')[0])
    assert.dom('[role="combobox"]').hasValue("France")
  })
})
