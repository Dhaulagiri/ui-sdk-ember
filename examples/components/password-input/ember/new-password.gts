import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Field } from "ember-ui-sdk/field"
import { PasswordInput } from "ember-ui-sdk/password-input"
import { Check, Eye, EyeOff, X } from "lucide"
import { icon } from "../../../shared/ember/icon"

const rules = [
  {
    label: "At least 8 characters",
    test: (password: string) => password.length >= 8,
  },
  { label: "A number", test: (password: string) => /\d/.test(password) },
  {
    label: "An uppercase and a lowercase letter",
    test: (password: string) =>
      /[a-z]/.test(password) && /[A-Z]/.test(password),
  },
]

export default class NewPassword extends Component {
  @tracked password = ""

  get rows() {
    return rules.map((rule) => ({
      label: rule.label,
      done: rule.test(this.password),
    }))
  }

  onValueChange = (value: string) => {
    this.password = value
  }

  <template>
    <Field @name="new-password" as |f|>
      <f.Label>Create a password</f.Label>
      <PasswordInput
        @value={{this.password}}
        @onValueChange={{this.onValueChange}}
        @autoComplete="new-password"
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
      <ul data-slot="stack" aria-label="Password requirements">
        {{#each this.rows key="label" as |rule|}}
          {{#if rule.done}}
            <li data-slot="row">
              {{icon Check}}
              <span data-slot="visually-hidden">Done:</span>
              {{rule.label}}
            </li>
          {{else}}
            <li data-slot="row">
              {{icon X}}
              <span data-slot="visually-hidden">To do:</span>
              {{rule.label}}
            </li>
          {{/if}}
        {{/each}}
      </ul>
    </Field>
  </template>
}
