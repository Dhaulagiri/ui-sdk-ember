import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Tabs } from "ember-ui-sdk/tabs"
import { tabsOptions } from "tests/fixtures/page.ts"

export default class Fixture extends Component {
  activation = tabsOptions().activation
  values = ["overview", "activity", "watched", "plain"]
  @tracked action = ""
  @tracked reason = ""

  onValueChange = (value: string | null, details: { reason: string }) => {
    this.action = value ?? ""
    this.reason = details.reason
  }

  <template>
    <div class="fixture">
      <button>Before</button>
      <Tabs
        class="tabs"
        @defaultValue="overview"
        @activation={{this.activation}}
        @onValueChange={{this.onValueChange}}
        as |t|
      >
        <t.List class="tablist" aria-label="Project">
          <t.Tab @value="overview" @render={{true}} as |tab|>
            <a class="tab" href="#overview" {{tab.part}}>Overview</a>
          </t.Tab>
          <t.Tab @value="activity" @render={{true}} as |tab|>
            <a class="tab" href="#activity" {{tab.part}}>Activity</a>
          </t.Tab>
          <t.Tab @value="watched" @render={{true}} as |tab|>
            <button class="tab" {{tab.part}}>Watched{{#if
                tab.state.selected
              }}<span aria-hidden="true">
                  •</span>{{/if}}</button>
          </t.Tab>
          <t.Tab class="tab" @value="plain" as |tab|>
            <span
              class={{if tab.state.selected "is-selected" "is-unselected"}}
            >Plain</span>
          </t.Tab>
        </t.List>
        {{#each this.values as |value|}}
          <t.Panel class="panel" @value={{value}}>The {{value}} panel.</t.Panel>
        {{/each}}
      </Tabs>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
      <output role="status" aria-label="Reason">{{this.reason}}</output>
    </div>
  </template>
}
