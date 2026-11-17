import { module, test } from "qunit"
import { setupRenderingTest } from "ember-qunit"
import {
  click,
  focus,
  render,
  triggerKeyEvent,
  waitUntil,
} from "@ember/test-helpers"
import { precompileTemplate } from "@ember/template-compilation"
import { Tabs } from "ember-ui-sdk/tabs"
import { Dialog } from "ember-ui-sdk/dialog"
import * as primitive from "ember-ui-sdk/primitive"

module("Integration | packed addon", function (hooks) {
  setupRenderingTest(hooks)

  test("component and primitive entries load", function (assert) {
    assert.ok(Tabs)
    assert.ok(Dialog)
    assert.strictEqual(typeof primitive.attach, "function")
  })

  test("tabs render and respond to keyboard navigation", async function (assert) {
    await render(
      precompileTemplate(
        `<Tabs @defaultValue="a" as |t|>
        <t.List aria-label="Packed tabs">
          <t.Tab @value="a">Alpha</t.Tab>
          <t.Tab @value="b">Beta</t.Tab>
        </t.List>
        <t.Panel @value="a">Panel alpha</t.Panel>
        <t.Panel @value="b">Panel beta</t.Panel>
      </Tabs>`,
        { strictMode: true, scope: () => ({ Tabs }) }
      )
    )
    assert.dom('[role="tab"][aria-selected="true"]').hasText("Alpha")
    await focus('[role="tab"]')
    await triggerKeyEvent('[role="tab"]', "keydown", "ArrowRight")
    assert.dom('[role="tab"][aria-selected="true"]').hasText("Beta").isFocused()
    assert.dom('[role="tabpanel"]:not([hidden])').hasText("Panel beta")
  })

  test("dialog opens, dismisses and restores focus", async function (assert) {
    await render(
      precompileTemplate(
        `<Dialog as |d|>
        <d.Trigger>Open dialog</d.Trigger>
        <d.Content>
          <d.Title>Packed dialog</d.Title>
          <d.Close>Close dialog</d.Close>
        </d.Content>
      </Dialog>`,
        { strictMode: true, scope: () => ({ Dialog }) }
      )
    )
    await click('[data-slot="dialog-trigger"]')
    await waitUntil(() => document.querySelector('[role="dialog"]'))
    assert.dom('[role="dialog"]', document).exists()
    await triggerKeyEvent(document.activeElement, "keydown", "Escape")
    await waitUntil(() => !document.querySelector('[role="dialog"]'))
    assert.dom('[data-slot="dialog-trigger"]').isFocused()
  })
})
