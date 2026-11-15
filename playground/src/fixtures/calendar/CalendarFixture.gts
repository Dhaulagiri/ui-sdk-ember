import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import type { ChangeDetails } from "@ui-sdk/core"
import {
  Calendar,
  createCalendarController,
  type CalendarValue,
} from "ember-ui-sdk/calendar"
import {
  calendarAction,
  calendarFixture as f,
  calendarOptions,
} from "tests/fixtures/calendar.ts"

export default class CalendarFixture extends Component {
  f = f
  o = calendarOptions()
  controller = createCalendarController()
  offsets = Array.from({ length: this.o.months ?? 1 }, (_, offset) => offset)
  @tracked action = ""
  @tracked value: CalendarValue = this.o.defaultValue
  @tracked month = this.o.defaultMonth ?? f.today.slice(0, 7)

  get valueArg() {
    return this.o.controlled ? this.value : undefined
  }

  get monthArg() {
    return this.o.controlled ? this.month : undefined
  }

  get defaultValueArg() {
    return this.o.controlled ? undefined : this.o.defaultValue
  }

  get defaultMonthArg() {
    return this.o.controlled ? undefined : this.o.defaultMonth
  }

  onValueChange = (next: CalendarValue, details: ChangeDetails) => {
    this.value = next
    this.action = calendarAction("value", next, details.reason)
  }

  onMonthChange = (next: string, details: ChangeDetails) => {
    this.month = next
    this.action = calendarAction("month", next, details.reason)
  }

  focusDate = () => this.controller.focus(f.controller.date)

  <template>
    <div class="fixture" lang={{this.o.lang}}>
      <button>Before</button>
      <Calendar
        class="calendar"
        @today={{this.f.today}}
        @controller={{this.controller}}
        @mode={{this.o.mode}}
        @min={{this.o.min}}
        @max={{this.o.max}}
        @months={{this.o.months}}
        @pageBy={{this.o.pageBy}}
        @unavailable={{this.o.unavailable}}
        @weekStartsOn={{this.o.weekStartsOn}}
        @fixedWeeks={{this.o.fixedWeeks}}
        @showOutsideDays={{this.o.showOutsideDays}}
        @minDays={{this.o.minDays}}
        @maxDays={{this.o.maxDays}}
        @allowUnavailable={{this.o.allowUnavailable}}
        @disabled={{this.o.disabled}}
        @readOnly={{this.o.readOnly}}
        @value={{this.valueArg}}
        @month={{this.monthArg}}
        @defaultValue={{this.defaultValueArg}}
        @defaultMonth={{this.defaultMonthArg}}
        @onValueChange={{this.onValueChange}}
        @onMonthChange={{this.onMonthChange}}
        as |c|
      >
        <div class="calendar-header">
          <c.Previous class="calendar-step" />
          <c.Heading class="calendar-heading" />
          {{#if this.o.selects}}
            <c.MonthSelect />
            <c.YearSelect />
          {{/if}}
          <c.Next class="calendar-step" />
        </div>
        <div class="calendar-months">
          {{#each this.offsets as |offset|}}
            <c.Grid @offset={{offset}} class="calendar-grid" />
          {{/each}}
        </div>
      </Calendar>
      <button {{on "click" this.focusDate}}>{{this.f.controller.label}}</button>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
    </div>
  </template>
}
