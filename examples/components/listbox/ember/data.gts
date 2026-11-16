import Component from "@glimmer/component"
import { Listbox } from "ember-ui-sdk/listbox"
import { Check } from "lucide"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const plans = [
  { value: { id: "hobby", price: 0 }, label: "Hobby" },
  { value: { id: "pro", price: 20 }, label: "Pro" },
  { value: { id: "team", price: 50 }, label: "Team" },
  {
    value: { id: "enterprise", price: 200 },
    label: "Enterprise",
    disabled: true,
  },
]

const defaultPlan = plans[1].value

export default class Data extends Component {
  log = useLog(this)
  plans = plans
  defaultPlan = defaultPlan

  onValueChange = (plan: { id: string; price: number } | null) => {
    this.log(plan ? `${plan.id}, $${plan.price} a month` : "No plan")
  }

  itemToValue = (plan: { id: string }) => plan.id

  isItemEqualToValue = (plan: { id: string }, selected: { id: string }) =>
    plan.id === selected.id

  <template>
    <Listbox
      @items={{this.plans}}
      @defaultValue={{this.defaultPlan}}
      @onValueChange={{this.onValueChange}}
      @itemToValue={{this.itemToValue}}
      @isItemEqualToValue={{this.isItemEqualToValue}}
      aria-label="Plan"
      as |l|
    >
      {{#each this.plans key="value.id" as |plan|}}
        <l.Item @value={{plan.value}} @disabled={{plan.disabled}} as |i|>
          {{plan.label}}
          <i.Indicator>{{icon Check}}</i.Indicator>
        </l.Item>
      {{/each}}
    </Listbox>
  </template>
}
