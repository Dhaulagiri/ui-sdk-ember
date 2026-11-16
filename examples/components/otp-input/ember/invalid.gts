import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Field } from "ember-ui-sdk/field"
import { OTPInput } from "ember-ui-sdk/otp-input"

export default class Invalid extends Component {
  @tracked invalid = true

  clearInvalid = () => {
    this.invalid = false
  }

  <template>
    <Field @invalid={{this.invalid}} as |f|>
      <f.Label>Verification code</f.Label>
      <OTPInput
        @defaultValue="482913"
        @onValueChange={{this.clearInvalid}}
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
      <f.Error>That code has expired. Request a new one.</f.Error>
    </Field>
  </template>
}
