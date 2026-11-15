import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import type { CheckedState } from "@ui-sdk/core/checkbox"
import { Checkbox, CheckboxGroup } from "ember-ui-sdk/checkbox"
import { Field } from "ember-ui-sdk/field"
import { RadioGroup } from "ember-ui-sdk/radio"
import { Switch } from "ember-ui-sdk/switch"
import {
  formsFixture as f,
  formsOptions,
  serialize,
} from "tests/fixtures/forms.ts"

type Details = { cancel: () => void; canceled: boolean; source: string }

export default class FormsFixture extends Component {
  f = f
  options = formsOptions()
  all = f.toppings.items.map((item) => item.value)
  @tracked action = ""
  @tracked source = ""
  @tracked submitted = ""
  @tracked terms: CheckedState = false
  @tracked shipping = false

  report = (name: string, value: unknown, details: Details) => {
    if (this.options.cancel === name) {
      return details.cancel()
    }
    this.action = `${name}:${String(value)}`
    this.source = details.source
  }

  onTerms = (checked: CheckedState, details: Details) => {
    this.report(f.terms.name, checked, details)
    if (!details.canceled) {
      this.terms = checked
    }
  }

  onToppings = (value: string[], details: Details) =>
    this.report(f.toppings.name, value.join(","), details)

  onPlan = (value: string | null, details: Details) =>
    this.report(f.plan.name, value, details)

  onSwitch = (name: string, checked: boolean, details: Details) =>
    this.report(name, checked, details)

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    this.submitted = serialize(event.currentTarget as HTMLFormElement)
  }

  toggleShipping = () => (this.shipping = !this.shipping)

  <template>
    <div class="fixture">
      <button>Before</button>
      <form
        class="form"
        id={{this.f.formId}}
        aria-label={{this.f.formLabel}}
        {{on "submit" this.onSubmit}}
      >
        <Field as |field|>
          <div class="row">
            <Checkbox
              class="checkbox"
              @field={{field.field}}
              @name={{this.f.terms.name}}
              @value={{this.f.terms.value}}
              @required={{true}}
              @readOnly={{this.options.readOnly}}
              @checked={{if this.options.controlled this.terms}}
              @onCheckedChange={{this.onTerms}}
              as |c|
            >
              <c.Indicator class="checkbox-indicator" />
            </Checkbox>
            <field.Label>{{this.f.terms.label}}</field.Label>
          </div>
          <field.Description>{{this.f.terms.description}}</field.Description>
          <field.Error
            class="field-error"
            @match="valueMissing"
          >{{this.f.terms.error}}</field.Error>
        </Field>

        <fieldset>
          <legend
            id={{this.f.toppings.legendId}}
          >{{this.f.toppings.legend}}</legend>
          <CheckboxGroup
            class="form"
            aria-labelledby={{this.f.toppings.legendId}}
            @name={{this.f.toppings.name}}
            @defaultValue={{this.f.toppings.defaultValue}}
            @allValues={{this.all}}
            @required={{this.options.toppingsRequired}}
            @onValueChange={{this.onToppings}}
            as |g|
          >
            <label>
              <g.Checkbox class="checkbox" @parent={{true}} as |c|>
                <c.Indicator class="checkbox-indicator" />
              </g.Checkbox>
              {{this.f.toppings.parent}}
            </label>
            {{#each this.f.toppings.items key="value" as |item|}}
              <label>
                <g.Checkbox class="checkbox" @value={{item.value}} as |c|>
                  <c.Indicator class="checkbox-indicator" />
                </g.Checkbox>
                {{item.label}}
              </label>
            {{/each}}
          </CheckboxGroup>
        </fieldset>

        {{#each this.f.switches key="name" as |item|}}
          <label>
            <Switch
              class="switch"
              @name={{item.name}}
              @defaultChecked={{item.defaultChecked}}
              @onCheckedChange={{fn this.onSwitch item.name}}
              as |s|
            >
              <s.Thumb class="switch-thumb" />
            </Switch>
            {{item.label}}
          </label>
        {{/each}}

        <Field as |field|>
          <field.Label>{{this.f.plan.label}}</field.Label>
          <RadioGroup
            class="form"
            @field={{field.field}}
            @name={{this.f.plan.name}}
            @required={{true}}
            @defaultValue={{this.options.plan}}
            @readOnly={{this.options.readOnly}}
            @disabled={{this.options.disabled}}
            @loop={{this.options.loop}}
            @onValueChange={{this.onPlan}}
            as |g|
          >
            {{#each this.f.plan.items key="value" as |item|}}
              <label>
                <g.Radio
                  class="radio"
                  @value={{item.value}}
                  @disabled={{item.disabled}}
                  as |r|
                >
                  <r.Indicator class="radio-indicator" />
                </g.Radio>
                {{item.label}}
              </label>
            {{/each}}
          </RadioGroup>
          <field.Description>{{this.f.plan.description}}</field.Description>
          <field.Error class="field-error" />
        </Field>

        <Field @invalid={{this.options.invalid}} as |field|>
          <field.Label>{{this.f.email.label}}</field.Label>
          <field.Control type="email" name={{this.f.email.name}} required />
          <field.Description>{{this.f.email.description}}</field.Description>
          <field.Error class="field-error" />
        </Field>

        {{#if this.options.nickname}}
          <Field as |field|>
            <field.Label>{{this.f.nickname.label}}</field.Label>
            <field.Control name={{this.f.nickname.name}} required />
          </Field>
        {{/if}}

        <fieldset disabled={{this.shipping}}>
          <legend>{{this.f.shipping.legend}}</legend>
          <label>
            <Checkbox class="checkbox" @name={{this.f.shipping.name}} as |c|>
              <c.Indicator class="checkbox-indicator" />
            </Checkbox>
            {{this.f.shipping.label}}
          </label>
        </fieldset>

        <div class="row">
          <button type="submit">Save</button>
          <button type="reset">Reset</button>
        </div>
      </form>
      <label>
        <Checkbox
          class="checkbox"
          @form={{this.f.formId}}
          @name={{this.f.newsletter.name}}
          @value={{this.f.newsletter.value}}
          as |c|
        >
          <c.Indicator class="checkbox-indicator" />
        </Checkbox>
        {{this.f.newsletter.label}}
      </label>
      <button type="button" {{on "click" this.toggleShipping}}>Toggle shipping</button>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
      <output aria-label="Last source">{{this.source}}</output>
      <output role="status" aria-label="Submitted">{{this.submitted}}</output>
    </div>
  </template>
}
