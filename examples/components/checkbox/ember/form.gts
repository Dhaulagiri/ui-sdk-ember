import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Checkbox } from "ember-ui-sdk/checkbox"
import { Field } from "ember-ui-sdk/field"
import { Check } from "lucide"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

export default class Form extends Component {
  log = useLog(this)

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    const entries = [
      ...new FormData(event.currentTarget as HTMLFormElement),
    ].map(([name, value]) => `${name}=${value}`)
    this.log(
      entries.length ? `Submitted ${entries.join("&")}` : "Submitted nothing"
    )
  }

  <template>
    <form data-slot="stack" {{on "submit" this.onSubmit}}>
      <Field as |f|>
        <Checkbox
          @name="terms"
          @value="yes"
          @required={{true}}
          @field={{f.field}}
          as |c|
        >
          <c.Indicator>{{icon Check}}</c.Indicator>
        </Checkbox>
        <div data-slot="stack">
          <f.Label>Accept terms and conditions</f.Label>
          <f.Description>You agree to our Terms of Service and Privacy Policy.</f.Description>
        </div>
      </Field>
      <Field as |f|>
        <Checkbox
          @name="newsletter"
          @value="weekly"
          @defaultChecked={{true}}
          @field={{f.field}}
          as |c|
        >
          <c.Indicator>{{icon Check}}</c.Indicator>
        </Checkbox>
        <div data-slot="stack">
          <f.Label>Send me the weekly newsletter</f.Label>
          <f.Description>Product news and tips, once a week. Unsubscribe
            anytime.</f.Description>
        </div>
      </Field>
      <div data-slot="row">
        <button type="submit">Create Account</button>
        <button type="reset">Reset</button>
      </div>
    </form>
  </template>
}
