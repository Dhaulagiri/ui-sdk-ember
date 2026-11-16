import Component from "@glimmer/component"
import { todayDate } from "@ui-sdk/core/date"
import { ChevronLeft, ChevronRight } from "lucide"
import { on } from "@ember/modifier"
import { Calendar, createCalendarController } from "ember-ui-sdk/calendar"
import { icon } from "../../../shared/ember/icon"

export default class Controller extends Component {
  calendar = createCalendarController()

  select = (date: string) => {
    this.calendar.setValue(date)
    this.calendar.focus(date)
  }

  goToChristmas = () => this.select("2026-12-25")
  goToToday = () => this.select(todayDate())

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.goToChristmas}}>Go to Christmas</button>
        <button type="button" {{on "click" this.goToToday}}>Today</button>
      </div>
      <Calendar
        @controller={{this.calendar}}
        @defaultValue="2026-10-16"
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
