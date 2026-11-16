import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Field } from "ember-ui-sdk/field"
import { RadioGroup } from "ember-ui-sdk/radio"
import { useLog } from "../../../shared/ember/log"

const channels = [
  { value: "email", label: "Email only" },
  { value: "sms", label: "SMS only" },
  { value: "both", label: "Email and SMS" },
]

export default class Invalid extends Component {
  log = useLog(this)

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    this.log(
      `Saved updates=${new FormData(event.currentTarget as HTMLFormElement).get("updates")}`
    )
  }

  <template>
    <form data-slot="stack" {{on "submit" this.onSubmit}}>
      <Field as |f|>
        <f.Label>Order updates</f.Label>
        <f.Description>Choose how we tell you about your orders.</f.Description>
        <RadioGroup
          @name="updates"
          @required={{true}}
          @field={{f.field}}
          as |g|
        >
          {{#each channels key="value" as |channel|}}
            <label data-slot="label">
              <g.Radio @value={{channel.value}} as |r|>
                <r.Indicator />
              </g.Radio>
              {{channel.label}}
            </label>
          {{/each}}
        </RadioGroup>
        <f.Error>Choose how to get order updates.</f.Error>
      </Field>
      <div data-slot="row">
        <button type="submit" data-variant="solid">Save</button>
      </div>
    </form>
  </template>
}
