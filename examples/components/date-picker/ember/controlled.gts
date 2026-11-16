import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { ChevronLeft, ChevronRight, Calendar, X } from "lucide"
import type { DatePickerValue } from "@ui-sdk/core/date-picker"
import { DatePicker } from "ember-ui-sdk/date-picker"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

export default class Controlled extends Component {
  log = useLog(this)
  @tracked value: DatePickerValue = "2026-10-16"

  onValueChange = (next: DatePickerValue, details: { reason: string }) => {
    this.value = next
    this.log(`${next ?? "No date"} (${details.reason})`)
  }

  <template>
    <DatePicker
      @value={{this.value}}
      @onValueChange={{this.onValueChange}}
      as |dp|
    >
      <div data-slot="row">
        <dp.Input aria-label="Due date" />
        <dp.Trigger data-variant="ghost">{{icon Calendar}}</dp.Trigger>
      </div>
      <dp.Hint />
      <dp.Content>
        <div data-slot="row">
          <dp.Previous data-variant="ghost">{{icon ChevronLeft}}</dp.Previous>
          <dp.Heading />
          <dp.Next data-variant="ghost">{{icon ChevronRight}}</dp.Next>
        </div>
        <dp.Grid />
      </dp.Content>
    </DatePicker>
  </template>
}
