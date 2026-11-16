import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Field } from "ember-ui-sdk/field"
import { PasswordInput } from "ember-ui-sdk/password-input"
import { Eye, EyeOff } from "lucide"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

export default class Controlled extends Component {
  log = useLog(this)
  @tracked visible = false

  onVisibleChange = (next: boolean, details: { reason: string }) => {
    this.visible = next
    this.log(`${next ? "Shown" : "Hidden"} (${details.reason})`)
  }

  <template>
    <Field @name="password" as |f|>
      <f.Label>Password</f.Label>
      <PasswordInput
        @visible={{this.visible}}
        @onVisibleChange={{this.onVisibleChange}}
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
  </template>
}
