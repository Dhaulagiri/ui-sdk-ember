import Component from "@glimmer/component"
import { array } from "@ember/helper"
import { on } from "@ember/modifier"
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

export default class Form extends Component {
  log = useLog(this)

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    this.log(
      `Ordered ${new FormData(event.currentTarget as HTMLFormElement).getAll("toppings").join(", ")}`
    )
  }

  <template>
    <div data-slot="stack">
      <Listbox
        @multiple={{true}}
        @name="toppings"
        @form="pizza-order"
        @required={{true}}
        @defaultValue={{array "cheese"}}
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
      <form id="pizza-order" data-slot="row" {{on "submit" this.onSubmit}}>
        <button type="reset">Reset</button>
        <button data-variant="solid">Order</button>
      </form>
    </div>
  </template>
}
