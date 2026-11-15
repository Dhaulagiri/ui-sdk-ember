import Component from "@glimmer/component"
import { calendar } from "@ui-sdk/core/calendar"
import { usePart, type PartSignature } from "../use-part"
import CalendarWeekdays from "./calendar-weekdays.gts"
import CalendarWeeks from "./calendar-weeks.gts"

/** One month's grid, a table. `@offset` picks which of the months shown, from 0. Without a block it renders its weekdays and weeks. Yields its `Weekdays` and `Weeks`. */
class CalendarGrid extends Component<
  PartSignature<typeof calendar, "grid", HTMLTableElement, { offset?: number }>
> {
  part = usePart(
    this,
    () => this.args.handle,
    "grid",
    () => ({
      offset: this.args.offset ?? 0,
      id: String(this.args.offset ?? 0),
    })
  )

  <template>
    {{#let
      (hash
        part=this.part.modifier
        state=this.part.state
        Weekdays=(component
          CalendarWeekdays
          handle=@handle
          offset=@offset
          weekdays=this.part.state.weekdays
        )
        Weeks=(component
          CalendarWeeks
          handle=@handle
          offset=@offset
          weeks=this.part.state.weeks
        )
      )
      as |grid|
    }}
      {{#if @render}}
        {{yield grid}}
      {{else}}
        <table ...attributes {{this.part.modifier}}>
          {{~#if (has-block)}}{{yield grid}}{{else~}}
            <grid.Weekdays />
            {{~!~}}
            <grid.Weeks />
          {{~/if~}}
        </table>
      {{/if}}
    {{/let}}
  </template>
}

export default CalendarGrid
