import { hash } from "@ember/helper"
import Component from "@glimmer/component"
import { calendar } from "@ui-sdk/core/calendar"
import { usePart } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import CalendarDay from "./calendar-day.gts"
import CalendarGrid from "./calendar-grid.gts"
import CalendarHeading from "./calendar-heading.gts"
import CalendarMonthSelect from "./calendar-month-select.gts"
import CalendarNext from "./calendar-next.gts"
import CalendarPrevious from "./calendar-previous.gts"
import CalendarYearSelect from "./calendar-year-select.gts"

/**
 * Months of days with one tab stop. Without a block it renders a heading,
 * Previous and Next, and a grid for each month. Takes Calendar's options as
 * arguments, like `@mode`, `@value` with `@onValueChange`, and `@months`.
 */
class Calendar extends Component<{
  Element: HTMLDivElement
  Args: Record<string, unknown> & {
    /** How many months show side by side. */
    months?: number
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: { default: [Record<string, any>] }
}> {
  handle = usePrimitive(this, calendar)
  root = usePart(this, () => this.handle, "root")

  get offsets() {
    const months = this.args.months
    return Array.from(
      { length: Math.max(1, Math.floor(months ?? 1) || 1) },
      (_, offset) => offset
    )
  }

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        Previous=(component CalendarPrevious handle=this.handle)
        Next=(component CalendarNext handle=this.handle)
        Heading=(component CalendarHeading handle=this.handle)
        MonthSelect=(component CalendarMonthSelect handle=this.handle)
        YearSelect=(component CalendarYearSelect handle=this.handle)
        Grid=(component CalendarGrid handle=this.handle)
        Day=(component CalendarDay handle=this.handle)
      )
      as |c|
    }}
      {{#if @render}}
        {{yield c}}
      {{else}}
        <div ...attributes {{this.root.modifier}}>
          {{~#if (has-block)}}{{yield c}}{{else~}}
            <div><c.Previous /><c.Heading /><c.Next /></div>
            {{~#each this.offsets as |offset|~}}
              <c.Grid @offset={{offset}} />
            {{~/each~}}
          {{~/if~}}
        </div>
      {{/if}}
    {{/let}}
  </template>
}

export default Calendar
