import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Field } from "ember-ui-sdk/field"
import { PasswordInput } from "ember-ui-sdk/password-input"
import { Eye, EyeOff } from "lucide"
import { icon } from "../../../shared/ember/icon"

const levels = [1, 2, 3, 4]
const names = ["Weak", "Weak", "Fair", "Good", "Strong"]

export default class Value extends Component {
  @tracked value = ""

  onValueChange = (value: string) => {
    this.value = value
  }

  get score() {
    return [
      this.value.length >= 8,
      this.value.length >= 12,
      /[a-z]/.test(this.value) && /[A-Z]/.test(this.value),
      /\d/.test(this.value) && /[^a-zA-Z\d]/.test(this.value),
    ].filter(Boolean).length
  }

  get on() {
    return levels.map((level) => (this.score >= level ? "" : undefined))
  }

  get status() {
    return this.value
      ? `Strength: ${names[this.score]} (${this.value.length} characters)`
      : "Type a password to rate it."
  }

  <template>
    <Field @name="new-password" as |f|>
      <f.Label>New password</f.Label>
      <PasswordInput
        @value={{this.value}}
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
      <div data-slot="strength" aria-hidden="true">
        {{#each this.on as |on|}}
          <div data-on={{on}}></div>
        {{/each}}
      </div>
      <output data-slot="output">{{this.status}}</output>
    </Field>
  </template>
}
