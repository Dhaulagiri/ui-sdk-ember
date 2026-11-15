import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import type { ChangeDetails } from "@ui-sdk/core"
import { Field } from "ember-ui-sdk/field"
import {
  createPasswordInputController,
  PasswordInput,
} from "ember-ui-sdk/password-input"
import {
  passwordInputAction,
  passwordInputFixture,
  passwordInputOptions,
} from "tests/fixtures/password-input.ts"

const { form: formLabels, email, password } = passwordInputFixture

export default class PasswordInputFixture extends Component {
  form = formLabels
  email = email
  password = password
  fixture = passwordInputFixture
  options = passwordInputOptions()
  reveal = createPasswordInputController()
  @tracked action = ""
  @tracked visible = !!this.options.defaultVisible

  onVisibleChange = (next: boolean, details: ChangeDetails) => {
    if (this.options.cancel) {
      return details.cancel()
    }
    this.visible = next
    this.action = passwordInputAction.visible(next, details.reason)
  }

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    const field = (event.currentTarget as HTMLFormElement).elements.namedItem(
      password.name
    ) as HTMLInputElement
    this.action = passwordInputAction.submit(field.type)
  }

  toggleVisible = () => this.reveal.toggleVisible()

  <template>
    <div class="fixture">
      <button>Before</button>
      <form
        aria-label={{this.form.label}}
        class="password-form"
        {{on "submit" this.onSubmit}}
      >
        <fieldset>
          <legend>{{this.form.account}}</legend>
          <label>
            {{this.email.label}}
            <input
              class="input"
              name={{this.email.name}}
              {{! @glint-expect-error defaultValue is a property, not an attribute }}
              defaultValue={{this.email.defaultValue}}
            />
          </label>
          <Field as |field|>
            <field.Label>{{this.password.label}}</field.Label>
            <PasswordInput
              class="password-input"
              @field={{field.field}}
              @name={{this.password.name}}
              @controller={{this.reveal}}
              @defaultVisible={{if
                this.options.controlled
                undefined
                this.options.defaultVisible
              }}
              @visible={{if this.options.controlled this.visible}}
              @disabled={{this.options.disabled}}
              @readOnly={{this.options.readOnly}}
              @autoComplete={{this.options.autoComplete}}
              @onVisibleChange={{this.onVisibleChange}}
              as |p|
            >
              <p.Control class="input" />
              <p.Toggle
                class="password-toggle"
                aria-label={{this.password.toggle}}
              >
                <span aria-hidden="true">👁</span>
              </p.Toggle>
            </PasswordInput>
            <field.Description>{{this.password.description}}</field.Description>
          </Field>
          <p class="caps-lock">{{this.password.capsLock}}</p>
        </fieldset>
        <button type="submit">{{this.form.submit}}</button>
        <button type="reset">{{this.form.reset}}</button>
      </form>
      <button
        {{on "click" this.toggleVisible}}
      >{{this.fixture.controller}}</button>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
    </div>
  </template>
}
