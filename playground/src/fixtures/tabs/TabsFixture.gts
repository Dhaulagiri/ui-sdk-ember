import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { createTabsController } from "@ui-sdk/core/tabs"
import { Tabs } from "ember-ui-sdk/tabs"
import { tabsOptions } from "tests/fixtures/page.ts"
import { tabsFixture } from "tests/fixtures/tabs.ts"

export default class TabsFixture extends Component {
  controller = createTabsController()
  options = tabsOptions()
  @tracked action = ""

  onValueChange = (value: string | null, details: { cancel: () => void }) => {
    if (value === this.options.cancel) {
      return details.cancel()
    }
    this.action = value ?? ""
  }

  select = (value: string) => this.controller.select(value)

  <template>
    <div class="fixture">
      <button>Before</button>
      <Tabs
        class="tabs"
        @defaultValue={{this.options.defaultValue}}
        @activation={{this.options.activation}}
        @orientation={{this.options.orientation}}
        @controller={{this.controller}}
        @onValueChange={{this.onValueChange}}
        as |t|
      >
        <t.List class="tablist" aria-label={{tabsFixture.label}}>
          {{#each tabsFixture.tabs key="value" as |tab|}}
            <t.Tab
              class="tab"
              @value={{tab.value}}
              @disabled={{tab.disabled}}
            >{{tab.label}}</t.Tab>
          {{/each}}
          <t.Indicator class="indicator" />
        </t.List>
        {{#each tabsFixture.tabs key="value" as |tab|}}
          <t.Panel
            class="panel"
            @value={{tab.value}}
            @keepMounted={{this.options.keepMounted}}
          >
            {{tab.content}}
            {{#if tab.field}}
              <label> {{tab.field}} <input type="password" /></label>
            {{/if}}
          </t.Panel>
        {{/each}}
      </Tabs>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
      <button {{on "click" (fn this.select "notifications")}}>Show notifications</button>
    </div>
  </template>
}
