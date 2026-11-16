import Component from "@glimmer/component"
import { Field } from "ember-ui-sdk/field"
import { OTPInput } from "ember-ui-sdk/otp-input"
import { useLog } from "../../../shared/ember/log"

export default class Complete extends Component {
  log = useLog(this)

  onValueCommit = (value: string, details: { reason: string }) => {
    this.log(`Checking ${value} (${details.reason})`)
  }

  <template>
    <Field as |f|>
      <f.Label>Verification code</f.Label>
      <OTPInput @onValueCommit={{this.onValueCommit}} @field={{f.field}} as |o|>
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
