import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Command } from "ember-ui-sdk/command"
import { commandFixture as f } from "tests/fixtures/command.ts"

const items = f.groups[0].items.slice(0, 2)

export default class CommandRenderFixture extends Component {
  @tracked action = ""

  onAction = (value: string) => {
    this.action = `action:${value}`
  }

  <template>
    <div class="fixture">
      <button>Before</button>
      <Command @render={{true}} @onAction={{this.onAction}} as |c|>
        <div
          class="command {{if c.state.page 'is-paged' 'is-first'}}"
          {{c.part}}
        >
          <c.Input class="input" aria-label={{f.input}} />
          <c.List class="command-list">
            <c.Item @value="docs" @render={{true}} as |item|>
              <a class="item" href="#docs" {{item.part}}>Docs</a>
            </c.Item>
            {{#each items key="value" as |entry|}}
              <c.Item
                @value={{entry.value}}
                @label={{entry.label}}
                @render={{true}}
                as |item|
              >
                <div
                  class="item {{if item.state.highlighted 'is-highlighted'}}"
                  {{item.part}}
                >
                  {{~entry.label}}{{if item.state.highlighted " ←"~}}
                </div>
              </c.Item>
            {{/each}}
          </c.List>
        </div>
      </Command>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
    </div>
  </template>
}
