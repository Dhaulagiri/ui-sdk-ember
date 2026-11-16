import Component from "@glimmer/component"
import { ChevronLeft, ChevronRight, Calendar } from "lucide"
import { DatePicker } from "ember-ui-sdk/date-picker"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

export default class Popup extends Component {
  log = useLog(this)

  onOpenChange = (open: boolean, details: { reason: string }) => {
    this.log(`${open ? "Opened" : "Closed"} (${details.reason})`)
  }

  onOpenChangeComplete = (open: boolean) => {
    if (!open) this.log("Finished closing")
  }

  onMonthChange = (month: string, details: { reason: string }) => {
    this.log(`Showing ${month} (${details.reason})`)
  }

  <template>
    <div data-slot="stack">
      <DatePicker
        @defaultOpen={{false}}
        @presentation="auto"
        @onOpenChange={{this.onOpenChange}}
        @onOpenChangeComplete={{this.onOpenChangeComplete}}
        @onMonthChange={{this.onMonthChange}}
        as |dp|
      >
        <div id="popup-row" data-slot="row">
          <dp.Input aria-label="Due date" />
          <dp.Trigger data-variant="ghost">{{icon Calendar}}</dp.Trigger>
        </div>
        <dp.Hint />
        <dp.Content
          @anchor="#popup-row"
          @sideOffset={{6}}
          @collisionPadding={{16}}
          @keepMounted={{true}}
        >
          <div data-slot="row">
            <dp.Previous data-variant="ghost">{{icon ChevronLeft}}</dp.Previous>
            <dp.Heading />
            <dp.Next data-variant="ghost">{{icon ChevronRight}}</dp.Next>
          </div>
          <dp.Grid />
        </dp.Content>
      </DatePicker>
    </div>
  </template>
}
