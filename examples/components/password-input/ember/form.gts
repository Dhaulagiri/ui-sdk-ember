import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"
import { PasswordInput } from "ember-ui-sdk/password-input"
import { Eye, EyeOff } from "lucide"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

export default class Form extends Component {
  log = useLog(this)

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    const data = new FormData(event.currentTarget as HTMLFormElement)
    const length = String(data.get("password")).length
    this.log(
      `Signed in as ${data.get("email")}, with a password of ${length} characters`
    )
  }

  <template>
    <div data-slot="stack">
      <form data-slot="stack" id="sign-in" {{on "submit" this.onSubmit}}>
        <Field @name="email" as |f|>
          <f.Label>Email</f.Label>
          <Input
            type="email"
            required
            autocomplete="username"
            @field={{f.field}}
          />
        </Field>
      </form>
      <Field as |f|>
        <f.Label>Password</f.Label>
        <PasswordInput
          @name="password"
          @form="sign-in"
          @required={{true}}
          as |p|
        >
          <p.Control @field={{f.field}} />
          <p.Toggle aria-label="Show password" as |t|>
            {{#if t.state.visible}}
              {{icon EyeOff}}
            {{else}}
              {{icon Eye}}
            {{/if}}
          </p.Toggle>
        </PasswordInput>
      </Field>
      <div data-slot="row">
        <button type="submit" form="sign-in" data-variant="solid">Sign In</button>
        <button type="reset" form="sign-in">Reset</button>
      </div>
    </div>
  </template>
}
