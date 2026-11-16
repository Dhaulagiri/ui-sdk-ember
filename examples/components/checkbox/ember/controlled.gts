import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import {
  Checkbox,
  createCheckboxController,
  type CheckedState,
} from "ember-ui-sdk/checkbox"
import { Check } from "lucide"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

export default class Controlled extends Component {
  log = useLog(this)
  updates = createCheckboxController()
  @tracked checked: CheckedState = false

  toggle = () => this.updates.toggle()

  onCheckedChange = (next: CheckedState, details: { reason: string }) => {
    this.checked = next
    const state =
      next === "indeterminate" ? "Mixed" : next ? "Checked" : "Unchecked"
    this.log(`${state} (${details.reason})`)
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.toggle}}>Toggle</button>
      </div>
      <label data-slot="label">
        <Checkbox
          @checked={{this.checked}}
          @controller={{this.updates}}
          @onCheckedChange={{this.onCheckedChange}}
          as |c|
        >
          <c.Indicator>{{icon Check}}</c.Indicator>
        </Checkbox>
        Email me about product updates
      </label>
    </div>
  </template>
}
