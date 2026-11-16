import Component from "@glimmer/component"
import { array } from "@ember/helper"
import { Listbox } from "ember-ui-sdk/listbox"
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

export default class Multiple extends Component {
  log = useLog(this)

  onValueChange = (value: string[], details: { reason: string }) => {
    this.log(`${value.join(", ") || "Nothing"} (${details.reason})`)
  }

  <template>
    <Listbox
      @multiple={{true}}
      @defaultValue={{array "cheese" "onion"}}
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
  </template>
}
