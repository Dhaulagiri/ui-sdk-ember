import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import type { ChangeDetails } from "@ui-sdk/core"
import { DatePicker } from "ember-ui-sdk/date-picker"
import {
  datePickerAction,
  datePickerFixture as f,
  datePickerOptions,
} from "tests/fixtures/date-picker.ts"

export default class DatePickerFixture extends Component {
  options = datePickerOptions()
  range = this.options.mode === "range"
  preset = this.range ? f.rangePreset : f.preset
  today = f.today
  lang = this.options.lang
  @tracked action = ""
  @tracked submitted = ""

  get label() {
    return this.range ? "Stay" : "Due date"
  }

  get inputLabel() {
    return this.range ? "Start date" : undefined
  }

  get name() {
    return this.range ? undefined : f.name
  }

  get startName() {
    return this.range ? "start" : undefined
  }

  get endName() {
    return this.range ? "end" : undefined
  }

  onValueChange = (next: unknown, details: ChangeDetails) => {
    this.action = datePickerAction("value", next, details.reason)
  }

  onOpenChange = (next: unknown, details: ChangeDetails) => {
    this.action = datePickerAction("open", next, details.reason)
  }

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    this.submitted = JSON.stringify([
      ...new FormData(event.currentTarget as HTMLFormElement),
    ])
  }

  <template>
    <div class="fixture" lang={{this.lang}}>
      <button>Before</button>
      <form {{on "submit" this.onSubmit}}>
        <label for="date-start">{{this.label}}</label>
        <DatePicker
          class="date-picker"
          @today={{this.today}}
          @name={{this.name}}
          @startName={{this.startName}}
          @endName={{this.endName}}
          @mode={{this.options.mode}}
          @defaultValue={{this.options.defaultValue}}
          @min={{this.options.min}}
          @max={{this.options.max}}
          @unavailable={{this.options.unavailable}}
          @required={{this.options.required}}
          @disabled={{this.options.disabled}}
          @readOnly={{this.options.readOnly}}
          @closeOnSelect={{this.options.closeOnSelect}}
          @minDays={{this.options.minDays}}
          @maxDays={{this.options.maxDays}}
          @container={{this.options.container}}
          @onValueChange={{this.onValueChange}}
          @onOpenChange={{this.onOpenChange}}
          as |dp|
        >
          <dp.Input @id="date-start" aria-label={{this.inputLabel}} />
          {{#if this.range}}<dp.Input
              @end={{true}}
              aria-label="End date"
            />{{/if}}
          <dp.Trigger />
          <dp.Clear>Clear</dp.Clear>
          <dp.Hint class="date-picker-hint" />
          <dp.Content class="date-picker-content">
            <div class="calendar-header">
              <dp.Previous class="calendar-step" />
              <dp.Heading class="calendar-heading" />
              <dp.Next class="calendar-step" />
            </div>
            <dp.Grid class="calendar-grid" />
            <dp.Preset
              @value={{this.preset.value}}
            >{{this.preset.label}}</dp.Preset>
          </dp.Content>
        </DatePicker>
        <button type="submit">Submit</button>
        <button type="reset">Reset</button>
      </form>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
      <output role="status" aria-label="Submitted">{{this.submitted}}</output>
    </div>
  </template>
}
