import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { ChevronLeft, ChevronRight } from "lucide"
import { Calendar } from "ember-ui-sdk/calendar"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

export default class Controlled extends Component {
  log = useLog(this)
  @tracked value: string | null = "2026-10-16"
  @tracked month = "2026-10"

  onValueChange = (next: unknown, details: { reason: string }) => {
    this.value = next as string
    this.log(`Selected ${String(next)} (${details.reason})`)
  }

  onMonthChange = (next: string, details: { reason: string }) => {
    this.month = next
    this.log(`Showing ${next} (${details.reason})`)
  }

  <template>
    <div>
      <Calendar
        @value={{this.value}}
        @onValueChange={{this.onValueChange}}
        @month={{this.month}}
        @onMonthChange={{this.onMonthChange}}
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
