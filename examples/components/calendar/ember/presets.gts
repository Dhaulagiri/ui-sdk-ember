import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { fn } from "@ember/helper"
import { addDays, endOfMonth, startOfMonth } from "@ui-sdk/core/date"
import { ChevronLeft, ChevronRight } from "lucide"
import { Calendar, createCalendarController } from "ember-ui-sdk/calendar"
import { icon } from "../../../shared/ember/icon"

const today = "2026-10-16"

const presets = [
  { label: "Last 7 Days", range: [addDays(today, -6), today] },
  { label: "This Month", range: [startOfMonth(today), endOfMonth(today)] },
  { label: "Next 30 Days", range: [today, addDays(today, 29)] },
]

export default class Presets extends Component {
  presets = presets
  today = today
  calendar = createCalendarController()

  choose = (preset: { range: string[] }) => {
    this.calendar.setValue([...preset.range])
    this.calendar.focus(preset.range[0])
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        {{#each this.presets key="label" as |preset|}}
          <button
            type="button"
            data-size="sm"
            {{on "click" (fn this.choose preset)}}
          >
            {{preset.label}}
          </button>
        {{/each}}
      </div>
      <Calendar
        @mode="range"
        @controller={{this.calendar}}
        @today={{this.today}}
        @defaultMonth="2026-10"
        as |c|
      >
        <div data-slot="row">
          <c.Previous data-variant="ghost">{{icon ChevronLeft}}</c.Previous>
          <c.Heading />
          <c.Next data-variant="ghost">{{icon ChevronRight}}</c.Next>
        </div>
        <c.Grid />
      </Calendar>
    </div>
  </template>
}
