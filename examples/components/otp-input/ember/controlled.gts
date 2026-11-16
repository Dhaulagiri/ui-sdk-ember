import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Field } from "ember-ui-sdk/field"
import { OTPInput } from "ember-ui-sdk/otp-input"
import { useLog } from "../../../shared/ember/log"

export default class Controlled extends Component {
  log = useLog(this)
  @tracked value = ""

  onValueChange = (next: string, details: { reason: string }) => {
    this.value = next
    this.log(`${next || "Empty"} (${details.reason})`)
  }

  <template>
    <Field as |f|>
      <f.Label>One-time password</f.Label>
      <OTPInput
        @value={{this.value}}
        @onValueChange={{this.onValueChange}}
        @field={{f.field}}
        as |o|
      >
        <o.Group>
          <o.Slot @index={{0}} />
          <o.Slot @index={{1}} />
          <o.Slot @index={{2}} />
          <o.Slot @index={{3}} />
          <o.Slot @index={{4}} />
          <o.Slot @index={{5}} />
        </o.Group>
      </OTPInput>
    </Field>
  </template>
}
