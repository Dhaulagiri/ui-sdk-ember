import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { tracked } from "@glimmer/tracking"
import { Field } from "ember-ui-sdk/field"
import { RadioGroup, createRadioGroupController } from "ember-ui-sdk/radio"
import { useLog } from "../../../shared/ember/log"

const plans = [
  { value: "starter", label: "Starter" },
  { value: "pro", label: "Pro" },
  { value: "team", label: "Team" },
]

export default class Controlled extends Component {
  log = useLog(this)
  planGroup = createRadioGroupController()
  @tracked value: string | null = "pro"

  chooseTeam = () => this.planGroup.setValue("team")

  onValueChange = (next: string | null, details: { reason: string }) => {
    this.value = next
    const label = plans.find((plan) => plan.value === next)?.label ?? "None"
    this.log(`${label} (${details.reason})`)
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.chooseTeam}}>Choose Team</button>
      </div>
      <Field as |f|>
        <f.Label>Plan</f.Label>
        <RadioGroup
          @value={{this.value}}
          @onValueChange={{this.onValueChange}}
          @controller={{this.planGroup}}
          @field={{f.field}}
          as |g|
        >
          {{#each plans key="value" as |plan|}}
            <label data-slot="label">
              <g.Radio @value={{plan.value}} as |r|>
                <r.Indicator />
              </g.Radio>
              {{plan.label}}
            </label>
          {{/each}}
        </RadioGroup>
      </Field>
    </div>
  </template>
}
