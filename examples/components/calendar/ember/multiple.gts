import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { ChevronLeft, ChevronRight } from "lucide"
import { Calendar } from "ember-ui-sdk/calendar"
import { icon } from "../../../shared/ember/icon"

export default class Multiple extends Component {
  @tracked dates: string[] = ["2026-10-07", "2026-10-16", "2026-10-26"]

  onValueChange = (value: unknown) => {
    this.dates = value as string[]
  }

  <template>
    <div>
      <Calendar
        @mode="multiple"
        @value={{this.dates}}
        @onValueChange={{this.onValueChange}}
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
