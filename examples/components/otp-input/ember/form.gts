import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Field } from "ember-ui-sdk/field"
import { OTPInput } from "ember-ui-sdk/otp-input"
import { useLog } from "../../../shared/ember/log"

export default class Form extends Component {
  log = useLog(this)

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    const data = [...new FormData(event.currentTarget as HTMLFormElement)].map(
      ([name, value]) => `${name}=${value}`
    )
    this.log(`Submitted ${data.join(", ")}`)
  }

  <template>
    <div data-slot="stack">
      <form id="verify-sign-in" {{on "submit" this.onSubmit}}>
        <Field as |f|>
          <f.Label>Verification code</f.Label>
          <OTPInput @name="code" @required={{true}} @field={{f.field}} as |o|>
            <o.Group>
              <o.Slot @index={{0}} />
              <o.Slot @index={{1}} />
              <o.Slot @index={{2}} />
              <o.Slot @index={{3}} />
              <o.Slot @index={{4}} />
              <o.Slot @index={{5}} />
            </o.Group>
          </OTPInput>
          <f.Description>Enter the six-digit code we sent to hollis@example.com.</f.Description>
          <f.Error />
        </Field>
      </form>
      <Field as |f|>
        <f.Label>Recovery code (optional)</f.Label>
        <OTPInput
          @name="recovery"
          @form="verify-sign-in"
          @maxLength={{8}}
          @pattern="alphanumeric"
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
            <o.Slot @index={{6}} />
            <o.Slot @index={{7}} />
          </o.Group>
        </OTPInput>
        <f.Error />
      </Field>
      <div data-slot="row">
        <button type="reset" form="verify-sign-in">Reset</button>
        <button
          type="submit"
          form="verify-sign-in"
          data-variant="solid"
        >Verify</button>
      </div>
    </div>
  </template>
}
