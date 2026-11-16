import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import {
  CheckboxGroup,
  createCheckboxGroupController,
} from "ember-ui-sdk/checkbox"
import { Check } from "lucide"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const days = [
  { value: "mon", label: "Monday" },
  { value: "tue", label: "Tuesday" },
  { value: "wed", label: "Wednesday" },
  { value: "thu", label: "Thursday" },
  { value: "fri", label: "Friday" },
  { value: "sat", label: "Saturday" },
  { value: "sun", label: "Sunday" },
]

const weekdays = ["mon", "tue", "wed", "thu", "fri"]

export default class GroupControlled extends Component {
  log = useLog(this)
  schedule = createCheckboxGroupController()
  @tracked value: string[] = ["mon", "tue"]

  selectWeekdays = () => this.schedule.setValue(weekdays)
  clear = () => this.schedule.setValue([])

  onValueChange = (next: string[], details: { reason: string }) => {
    this.value = next
    const names = days
      .filter((day) => next.includes(day.value))
      .map((day) => day.label)
    this.log(`${names.join(", ") || "No days"} (${details.reason})`)
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.selectWeekdays}}>Select Weekdays</button>
        <button type="button" {{on "click" this.clear}}>Clear</button>
      </div>
      <h3 id="controlled-days">Working days</h3>
      <CheckboxGroup
        @value={{this.value}}
        @controller={{this.schedule}}
        @onValueChange={{this.onValueChange}}
        aria-labelledby="controlled-days"
        as |g|
      >
        {{#each days key="value" as |day|}}
          <label data-slot="label">
            <g.Checkbox @value={{day.value}} as |c|>
              <c.Indicator>{{icon Check}}</c.Indicator>
            </g.Checkbox>
            {{day.label}}
          </label>
        {{/each}}
      </CheckboxGroup>
    </div>
  </template>
}
