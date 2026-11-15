import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Listbox } from "ember-ui-sdk/listbox"
import { listboxAction, listboxFixture as f } from "tests/fixtures/listbox.ts"

const items = f.items.slice(0, 3)

export default class Fixture extends Component {
  f = f
  items = items
  @tracked action = ""

  onValueChange = (value: unknown) => (this.action = listboxAction(value))

  <template>
    <div class="fixture">
      <button>Before</button>
      <Listbox
        @activation="manual"
        @onValueChange={{this.onValueChange}}
        @render={{true}}
        as |l|
      >
        <ul aria-label={{f.label}} class="listbox" {{l.part}}>
          <l.Item @value="docs" @render={{true}} as |item|>
            <a class="item" href="#docs" {{item.part}}>Docs</a>
          </l.Item>
          <l.Item @value="star" @render={{true}} as |item|>
            <li
              class="item
                {{if item.state.selected 'is-selected' 'is-unselected'}}"
              {{item.part}}
            >
              {{if item.state.selected "★" "☆"}}
              Star
            </li>
          </l.Item>
          {{#each this.items key="value" as |entry|}}
            <l.Item @value={{entry.value}} @render={{true}} as |item|>
              <li class="item" {{item.part}}>{{entry.label}}</li>
            </l.Item>
          {{/each}}
        </ul>
      </Listbox>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
    </div>
  </template>
}
