import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import type { ChangeDetails } from "@ui-sdk/core"
import type { InputValueChangeReason } from "@ui-sdk/core/input"
import { Field, FieldSet } from "ember-ui-sdk/field"
import { Input, InputGroup } from "ember-ui-sdk/input"
import { Textarea } from "ember-ui-sdk/textarea"
import {
  formFixture as f,
  formOptions,
  invalidOf,
  messageOf,
  save,
  serializeData,
  without,
  type FormErrors,
} from "tests/fixtures/form.ts"

const orUndefined = (value: boolean | undefined) => value || undefined
const errorText = (
  errors: FormErrors | undefined,
  name: string,
  text: string
) => messageOf(errors, name) || text

export default class FormFixture extends Component {
  f = f
  options = formOptions()
  invalidOf = invalidOf
  errorText = errorText
  @tracked errors: FormErrors | undefined = this.options.errors
  @tracked action = ""
  @tracked submitted = ""
  @tracked username = ""
  @tracked contactDisabled = false
  pending = false

  onSubmit = async (event: SubmitEvent) => {
    event.preventDefault()
    if (this.pending) {
      return
    }
    const data = new FormData(event.currentTarget as HTMLFormElement)
    this.pending = true
    try {
      const result = await save(data, this.options.action)
      this.errors = result
      if (!result) {
        this.submitted = serializeData(data)
      }
    } catch {
    } finally {
      this.pending = false
    }
  }

  onReset = () => (this.errors = undefined)

  onUsername = (
    value: string,
    details: ChangeDetails<InputValueChangeReason>
  ) => {
    if (this.options.noDigits && /\d/.test(value)) {
      return details.cancel()
    }
    this.action = `${f.username.name}:${value}:${details.reason}`
    this.username = value
    this.errors = without(this.errors, f.username.name)
  }

  onEmail = () => (this.errors = without(this.errors, f.email.name))

  onWebsite = (
    value: string,
    details: ChangeDetails<InputValueChangeReason>
  ) => {
    this.action = `${f.website.name}:${value}:${details.reason}`
  }

  toggleContact = () => (this.contactDisabled = !this.contactDisabled)

  <template>
    <div class="fixture">
      <button>Before</button>
      <form
        class="form"
        aria-label={{this.f.formLabel}}
        {{on "submit" this.onSubmit}}
        {{on "reset" this.onReset}}
      >
        <FieldSet
          class="form"
          @disabled={{orUndefined this.options.disabled}}
          as |s|
        >
          <s.Legend>{{this.f.profile.legend}}</s.Legend>
          <s.Description>{{this.f.profile.description}}</s.Description>
          <Field
            @name={{this.f.username.name}}
            @invalid={{invalidOf this.errors this.f.username.name}}
            as |field|
          >
            <field.Label class="label">{{this.f.username.label}}</field.Label>
            <Input
              class="input"
              required
              minlength="3"
              @field={{field.field}}
              @value={{if this.options.controlled this.username}}
              @onValueChange={{this.onUsername}}
            />
            <field.Description
            >{{this.f.username.description}}</field.Description>
            <field.Error class="field-error" as |e|>{{errorText
                this.errors
                this.f.username.name
                e.state.message
              }}</field.Error>
          </Field>
          <Field
            @name={{this.f.bio.name}}
            @invalid={{invalidOf this.errors this.f.bio.name}}
            as |field|
          >
            <field.Label class="label">{{this.f.bio.label}}</field.Label>
            <Textarea
              class="textarea"
              @field={{field.field}}
              @autoResize={{true}}
              @submitShortcut={{this.options.submitShortcut}}
            />
            <field.Description>{{this.f.bio.description}}</field.Description>
            <field.Error class="field-error" as |e|>{{errorText
                this.errors
                this.f.bio.name
                e.state.message
              }}</field.Error>
          </Field>
        </FieldSet>
        <FieldSet
          class="form"
          @disabled={{orUndefined this.contactDisabled}}
          as |s|
        >
          <s.Legend>{{this.f.contact.legend}}</s.Legend>
          <Field
            @name={{this.f.email.name}}
            @invalid={{invalidOf this.errors this.f.email.name}}
            as |field|
          >
            <field.Label class="label">{{this.f.email.label}}</field.Label>
            <Input
              class="input"
              type="email"
              @field={{field.field}}
              @defaultValue={{this.f.email.defaultValue}}
              @onValueChange={{this.onEmail}}
            />
            <field.Error class="field-error" as |e|>{{errorText
                this.errors
                this.f.email.name
                e.state.message
              }}</field.Error>
          </Field>
          <Field @name={{this.f.website.name}} as |field|>
            <field.Label class="label">{{this.f.website.label}}</field.Label>
            <InputGroup class="input-group" as |g|>
              <span>{{this.f.website.prefix}}</span>
              <Input
                class="input"
                @field={{field.field}}
                @onValueChange={{this.onWebsite}}
              />
              <g.Clear aria-label={{this.f.website.clear}}>×</g.Clear>
            </InputGroup>
          </Field>
        </FieldSet>
        <div class="row">
          <button type="submit">Save</button>
          <button type="reset">Reset</button>
        </div>
      </form>
      <button type="button" {{on "click" this.toggleContact}}>Toggle contact</button>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
      <output role="status" aria-label="Submitted">{{this.submitted}}</output>
    </div>
  </template>
}
