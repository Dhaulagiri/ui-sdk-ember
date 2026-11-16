import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { CheckboxGroup } from "ember-ui-sdk/checkbox"
import { Field } from "ember-ui-sdk/field"
import { Check } from "lucide"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const channels = [
  { value: "email", label: "Email" },
  { value: "sms", label: "SMS" },
  { value: "push", label: "Push notifications" },
]

export default class GroupField extends Component {
  log = useLog(this)

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    const entries = [
      ...new FormData(event.currentTarget as HTMLFormElement),
    ].map(([name, value]) => `${name}=${value}`)
    this.log(`Saved ${entries.join("&")}`)
  }

  <template>
    <form data-slot="stack" {{on "submit" this.onSubmit}}>
      <Field as |f|>
        <f.Label>Notifications</f.Label>
        <f.Description>Choose how we tell you about your orders.</f.Description>
        <CheckboxGroup
          @name="notifications"
          @required={{true}}
          @field={{f.field}}
          as |g|
        >
          {{#each channels key="value" as |channel|}}
            <label data-slot="label">
              <g.Checkbox @value={{channel.value}} as |c|>
                <c.Indicator>{{icon Check}}</c.Indicator>
              </g.Checkbox>
              {{channel.label}}
            </label>
          {{/each}}
        </CheckboxGroup>
        <div>
          <f.Error>Choose at least one way to be notified.</f.Error>
        </div>
      </Field>
      <button type="submit">Save</button>
    </form>
  </template>
}
