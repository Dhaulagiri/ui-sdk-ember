import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import type { ChangeDetails } from "@ui-sdk/core"
import { createDateInputController, DateInput } from "ember-ui-sdk/date-input"
import { Field } from "ember-ui-sdk/field"
import { TimeInput } from "ember-ui-sdk/time-input"
import {
  dateInputAction,
  dateInputFixture as f,
  dateInputOptions,
} from "tests/fixtures/date-input.ts"

export default class DateInputFixture extends Component {
  f = f
  controller = createDateInputController()
  options = dateInputOptions()
  @tracked action = ""
  @tracked submitted = ""

  onDateChange = (value: string | null, details: ChangeDetails) => {
    const { cancel } = this.options
    if (cancel && value === cancel) {
      return details.cancel()
    }
    this.action = dateInputAction.change("date", value, details.reason)
  }

  onTimeChange = (value: string | null, details: ChangeDetails) => {
    this.action = dateInputAction.change("time", value, details.reason)
  }

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    this.submitted = JSON.stringify([
      ...new FormData(event.currentTarget as HTMLFormElement),
    ])
  }

  setDate = () => this.controller.setValue(f.filled)
  clearDate = () => this.controller.clear()

  <template>
    <div class="fixture">
      <button>Before</button>
      <form aria-label={{this.f.form.label}} {{on "submit" this.onSubmit}}>
        <Field class="field" @name={{this.f.date.name}} as |field|>
          <field.Label>{{this.f.date.label}}</field.Label>
          <DateInput
            class="date-input"
            @field={{field.field}}
            @controller={{this.controller}}
            @defaultValue={{this.options.date.defaultValue}}
            @locale={{this.options.date.locale}}
            @granularity={{this.options.date.granularity}}
            @hourCycle={{this.options.date.hourCycle}}
            @min={{this.options.date.min}}
            @max={{this.options.date.max}}
            @unavailable={{this.options.date.unavailable}}
            @disabled={{this.options.disabled}}
            @readOnly={{this.options.readOnly}}
            @required={{this.options.required}}
            @onValueChange={{this.onDateChange}}
          />
          <field.Error class="field-error" />
        </Field>
        <Field class="field" @name={{this.f.time.name}} as |field|>
          <field.Label>{{this.f.time.label}}</field.Label>
          <TimeInput
            class="date-input"
            @field={{field.field}}
            @defaultValue={{this.options.time.defaultValue}}
            @locale={{this.options.time.locale}}
            @hourCycle={{this.options.time.hourCycle}}
            @disabled={{this.options.disabled}}
            @readOnly={{this.options.readOnly}}
            @required={{this.options.required}}
            @onValueChange={{this.onTimeChange}}
          />
        </Field>
        <button type="submit">{{this.f.form.submit}}</button>
        <button type="reset">{{this.f.form.reset}}</button>
      </form>
      <button {{on "click" this.setDate}}>Set date</button>
      <button {{on "click" this.clearDate}}>Clear date</button>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
      <output aria-label="Submitted">{{this.submitted}}</output>
    </div>
  </template>
}
