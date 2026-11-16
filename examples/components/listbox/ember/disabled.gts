import Component from "@glimmer/component"
import { array } from "@ember/helper"
import { on } from "@ember/modifier"
import { tracked } from "@glimmer/tracking"
import { Listbox } from "ember-ui-sdk/listbox"
import { Check } from "lucide"
import { icon } from "../../../shared/ember/icon"

const toppings = [
  { value: "basil", label: "Basil" },
  { value: "cheese", label: "Extra cheese" },
  { value: "mushroom", label: "Mushroom" },
  { value: "olive", label: "Olive" },
  { value: "onion", label: "Onion" },
  { value: "pepper", label: "Pepper" },
]

export default class Disabled extends Component {
  @tracked disabled = false

  toggle = () => {
    this.disabled = !this.disabled
  }

  isOlive = (value: string) => value === "olive"

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.toggle}}>
          {{if this.disabled "Enable the List" "Disable the List"}}
        </button>
      </div>
      <Listbox
        @multiple={{true}}
        @disabled={{this.disabled}}
        @defaultValue={{array "basil"}}
        aria-label="Toppings"
        as |l|
      >
        {{#each toppings key="value" as |topping|}}
          <l.Item
            @value={{topping.value}}
            @disabled={{this.isOlive topping.value}}
            as |i|
          >
            {{topping.label}}
            <i.Indicator>{{icon Check}}</i.Indicator>
          </l.Item>
        {{/each}}
      </Listbox>
    </div>
  </template>
}
