import Component from "@glimmer/component"
import { calendar, type CalendarGridCell } from "@ui-sdk/core/calendar"
import { usePart } from "../use-part"
import type { PrimitiveHandle } from "../use-primitive"
import CalendarDay from "./calendar-day.gts"

// A week's row, for CalendarWeeks, which renders one per week.
class CalendarWeek extends Component<{
  Args: {
    handle: PrimitiveHandle<typeof calendar>
    offset?: number
    index: number
    week: CalendarGridCell[]
    custom?: boolean
  }
  Blocks: { default: [Record<string, any>] }
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
