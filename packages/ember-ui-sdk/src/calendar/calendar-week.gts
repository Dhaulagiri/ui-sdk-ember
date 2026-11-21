import { hash } from "@ember/helper"
import Component from "@glimmer/component"
import type { WithBoundArgs } from "@glint/template"
import { calendar, type CalendarGridCell } from "@ui-sdk/core/calendar"
import { usePart } from "../use-part"
import type { PrimitiveHandle } from "../use-primitive"
import CalendarDay from "./calendar-day.gts"

/** What a custom week yields for each day it shows. */
type CalendarWeekYield = {
  /** The day's cell in the grid. */
  cell: CalendarGridCell
  /** The day, bound to its date. */
  Day: WithBoundArgs<typeof CalendarDay, "handle" | "offset" | "value">
}

// A week's row, for CalendarWeeks, which renders one per week.
class CalendarWeek extends Component<{
  Args: {
    handle: PrimitiveHandle<typeof calendar>
    offset?: number
    index: number
    week: CalendarGridCell[]
    custom?: boolean
  }
  Blocks: { default: [CalendarWeekYield] }
}> {
  row = usePart(
    this,
    () => this.args.handle,
    "week",
    () => ({
      id: `${this.args.offset ?? 0}-${this.args.index}`,
    })
  )

  <template>
    <tr {{this.row.modifier}}>
      {{~#each @week key="date" as |cell|~}}
        {{~#if cell.hidden~}}
          <td></td>
        {{~else if @custom~}}
          {{yield
            (hash
              cell=cell
              Day=(component
                CalendarDay handle=@handle offset=@offset value=cell.date
              )
            )
          }}
        {{~else~}}
          <CalendarDay
            @handle={{@handle}}
            @offset={{@offset}}
            @value={{cell.date}}
          />
        {{~/if~}}
      {{~/each~}}
    </tr>
  </template>
}

export default CalendarWeek
export type { CalendarWeekYield }
