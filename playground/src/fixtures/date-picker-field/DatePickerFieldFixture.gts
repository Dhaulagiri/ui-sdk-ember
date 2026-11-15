import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { DatePicker } from "ember-ui-sdk/date-picker"
import { Field } from "ember-ui-sdk/field"
import {
  datePickerFieldFixture as f,
  datePickerFieldOptions,
  datePickerFixture,
} from "tests/fixtures/date-picker.ts"

export default class DatePickerFieldFixture extends Component {
  f = f
  name = datePickerFixture.name
  today = datePickerFixture.today
  options = datePickerFieldOptions()
  @tracked submitted = ""
  @tracked shown = true

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    this.submitted = JSON.stringify([
      ...new FormData(event.currentTarget as HTMLFormElement),
    ])
  }

  remove = () => (this.shown = false)

  <template>
    <div class="fixture">
      <button>Before</button>
      <form {{on "submit" this.onSubmit}}>
        <Field
          class="field"
          @name={{this.name}}
          @disabled={{this.options.disabled}}
          as |field|
        >
          <field.Label>{{this.f.label}}</field.Label>
          {{#if this.shown}}
            <DatePicker
              class="date-picker"
              @field={{field.field}}
              @today={{this.today}}
              @required={{this.options.required}}
              as |dp|
            >
              <dp.Input />
              <dp.Trigger />
              <dp.Hint class="date-picker-hint" />
              <dp.Content class="date-picker-content" />
            </DatePicker>
          {{/if}}
          <field.Description>{{this.f.description}}</field.Description>
          <field.Error class="field-error" />
        </Field>
        <button type="submit">Submit</button>
        <button type="button" {{on "click" this.remove}}>Remove date picker</button>
      </form>
      <output role="status" aria-label="Submitted">{{this.submitted}}</output>
    </div>
  </template>
}
