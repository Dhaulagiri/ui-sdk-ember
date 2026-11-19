import { module, test } from "qunit"
import { setupRenderingTest } from "ember-qunit"
import {
  click,
  fillIn,
  focus,
  render,
  triggerKeyEvent,
  waitUntil,
} from "@ember/test-helpers"
import { precompileTemplate } from "@ember/template-compilation"
import { setComponentTemplate } from "@ember/component"
import templateOnly from "@ember/component/template-only"
import { hash } from "@ember/helper"
import Component from "@glimmer/component"
import { VERSION } from "@ember/version"
import config from "test-app/config/environment"
import { Tabs } from "ember-ui-sdk/tabs"
import { Dialog } from "ember-ui-sdk/dialog"
import { Combobox } from "ember-ui-sdk/combobox"
import * as primitive from "ember-ui-sdk/primitive"

// A tab of the app's own: it binds ui-sdk's tab part to the instance its
// root hands it as @handle, and renders unbound without one.
class AppTab extends Component {
  part = primitive.usePart(
    this,
    () => this.args.handle,
    "tab",
    () => ({ value: this.args.value })
  )
}
setComponentTemplate(
  precompileTemplate(
    `<button type="button" class="app-tab" ...attributes {{this.part.modifier}}>{{yield}}</button>`,
    { strictMode: true }
  ),
  AppTab
)

// The app's own root, which yields its tab bound to the instance, the way a
// design system wraps the tabs.
const AppTabs = setComponentTemplate(
  precompileTemplate(
    `<Tabs @defaultValue={{@defaultValue}} as |t|>
      {{yield (hash List=t.List Tab=(component AppTab handle=t.handle) Panel=t.Panel)}}
    </Tabs>`,
    { strictMode: true, scope: () => ({ Tabs, AppTab, hash }) }
  ),
  templateOnly()
)

module("Integration | packed addon", function (hooks) {
  setupRenderingTest(hooks)

  test("component and primitive entries load", function (assert) {
    assert.strictEqual(
      VERSION,
      config.emberVersion,
      "the selected Ember runtime is loaded"
    )
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

  test("a part another component renders binds to the root it is handed", async function (assert) {
    await render(
      precompileTemplate(
        `<AppTabs @defaultValue="b" as |tabs|>
          <tabs.List aria-label="App tabs">
            <tabs.Tab @value="a">Alpha</tabs.Tab>
            <tabs.Tab @value="b">Beta</tabs.Tab>
          </tabs.List>
          <tabs.Panel @value="a">Panel alpha</tabs.Panel>
          <tabs.Panel @value="b">Panel beta</tabs.Panel>
        </AppTabs>
        <AppTab id="alone">Alone</AppTab>`,
        { strictMode: true, scope: () => ({ AppTabs, AppTab }) }
      )
    )
    assert.dom('.app-tab[role="tab"]').exists({ count: 2 })
    assert.dom('.app-tab[aria-selected="true"]').hasText("Beta")
    await focus('.app-tab[aria-selected="true"]')
    await triggerKeyEvent(document.activeElement, "keydown", "ArrowLeft")
    assert.dom('.app-tab[aria-selected="true"]').hasText("Alpha").isFocused()
    assert.dom('[role="tabpanel"]:not([hidden])').hasText("Panel alpha")
    assert
      .dom("#alone")
      .doesNotHaveAttribute("role", "a part without a root binds nothing")
    await click("#alone")
    assert.dom('.app-tab[aria-selected="true"]').hasText("Alpha")
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

  test("combobox filters, selects with the keyboard and clears", async function (assert) {
    await render(
      precompileTemplate(
        `<Combobox as |c|>
          <c.Label>Country</c.Label>
          <c.Input />
          <c.Trigger>Choose country</c.Trigger>
          <c.Clear>Clear country</c.Clear>
          <c.Content>
            <c.Empty>No countries</c.Empty>
            <c.List>
              <c.Item @value="fr" as |item|>
                <item.Text>France</item.Text>
                <item.Indicator>Selected</item.Indicator>
              </c.Item>
              <c.Item @value="de" as |item|>
                <item.Text>Germany</item.Text>
                <item.Indicator>Selected</item.Indicator>
              </c.Item>
            </c.List>
          </c.Content>
        </Combobox>`,
        { strictMode: true, scope: () => ({ Combobox }) }
      )
    )
    assert
      .dom('[role="combobox"]')
      .hasAttribute(
        "aria-labelledby",
        document.querySelector('[data-slot="combobox-label"]').id
      )
    await click('[data-slot="combobox-trigger"]')
    await waitUntil(() => document.querySelector('[role="listbox"]'))
    await fillIn('[role="combobox"]', "Fran")
    await waitUntil(() =>
      [...document.querySelectorAll('[role="option"]')].some(
        (option) => option.textContent.includes("France") && !option.hidden
      )
    )
    assert.dom('[role="option"]:not([hidden])', document).exists({ count: 1 })
    await triggerKeyEvent('[role="combobox"]', "keydown", "ArrowDown")
    await triggerKeyEvent('[role="combobox"]', "keydown", "Enter")
    assert.dom('[role="combobox"]').hasValue("France")
    await click('[data-slot="combobox-clear"]')
    assert.dom('[role="combobox"]').hasValue("")
  })

  test("combobox chips remove a selected value", async function (assert) {
    const selected = ["fr"]
    await render(
      precompileTemplate(
        `<Combobox @multiple={{true}} @defaultValue={{selected}} as |c|>
          <c.Label>Countries</c.Label>
          <c.Input />
          <c.Chips>
            <c.Chip @value="fr" as |chip|>
              France <chip.Remove>Remove France</chip.Remove>
            </c.Chip>
          </c.Chips>
          <c.Content>
            <c.List><c.Item @value="fr" @label="France" /></c.List>
          </c.Content>
        </Combobox>`,
        { strictMode: true, scope: () => ({ Combobox, selected }) }
      )
    )
    assert.dom('input[type="hidden"]').hasValue("fr")
    await click('[data-slot="combobox-chip-remove"]')
    assert.dom('input[type="hidden"][value="fr"]').doesNotExist()
  })
})
