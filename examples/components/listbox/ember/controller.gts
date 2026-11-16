import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Listbox, createListboxController } from "ember-ui-sdk/listbox"
import { Check } from "lucide"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const toppings = [
  { value: "basil", label: "Basil" },
  { value: "cheese", label: "Extra cheese" },
  { value: "mushroom", label: "Mushroom" },
  { value: "olive", label: "Olive" },
  { value: "onion", label: "Onion" },
  { value: "pepper", label: "Pepper" },
]

export default class Controller extends Component {
  log = useLog(this)
  controller = createListboxController<string, true>()

  selectAll = () => this.controller.selectAll()
  clear = () => this.controller.clear()
  focus = () => this.controller.focus()

  onValueChange = (value: string[], details: { reason: string }) => {
    this.log(`${value.length} selected (${details.reason})`)
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.selectAll}}>Select All</button>
        <button type="button" {{on "click" this.clear}}>Clear</button>
        <button type="button" {{on "click" this.focus}}>Focus</button>
      </div>
      <Listbox
        @multiple={{true}}
        @controller={{this.controller}}
        @onValueChange={{this.onValueChange}}
        aria-label="Toppings"
        as |l|
      >
        {{#each toppings key="value" as |topping|}}
          <l.Item @value={{topping.value}} as |i|>
            {{topping.label}}
            <i.Indicator>{{icon Check}}</i.Indicator>
          </l.Item>
        {{/each}}
      </Listbox>
    </div>
  </template>
}
