import Component from "@glimmer/component"
import { ChevronLeft, ChevronRight } from "lucide"
import { Calendar } from "ember-ui-sdk/calendar"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

export default class RangeProgress extends Component {
  log = useLog(this)

  onAnchorChange = (anchor: string | null) => {
    this.log(anchor ? `Started on ${anchor}` : "Range finished")
  }

  onFocusedChange = (focused: string) => {
    this.log(`Focus on ${focused}`)
  }

  <template>
    <div>
      <Calendar
        @mode="range"
        @onAnchorChange={{this.onAnchorChange}}
        @onFocusedChange={{this.onFocusedChange}}
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
