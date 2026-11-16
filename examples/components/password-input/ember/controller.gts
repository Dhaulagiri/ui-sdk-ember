import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Field } from "ember-ui-sdk/field"
import {
  PasswordInput,
  createPasswordInputController,
} from "ember-ui-sdk/password-input"
import { Eye, EyeOff } from "lucide"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

export default class Controller extends Component {
  log = useLog(this)
  password = createPasswordInputController()

  suggest = () => {
    this.password.setValue("plum-kettle-orbit-42")
    this.password.setVisible(true)
  }

  toggle = () => this.password.toggleVisible()
  clear = () => this.password.clear()
  focus = () => this.password.focus()

  read = () =>
    this.log(
      `${this.password.getValue().length} characters, ${this.password.isVisible() ? "shown" : "hidden"}`
    )

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.suggest}}>Suggest</button>
        <button type="button" {{on "click" this.toggle}}>Toggle</button>
        <button type="button" {{on "click" this.clear}}>Clear</button>
        <button type="button" {{on "click" this.read}}>Read</button>
        <button type="button" {{on "click" this.focus}}>Focus</button>
      </div>
      <Field @name="new-password" as |f|>
        <f.Label>New password</f.Label>
        <PasswordInput
          @controller={{this.password}}
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
      </Field>
    </div>
  </template>
}
