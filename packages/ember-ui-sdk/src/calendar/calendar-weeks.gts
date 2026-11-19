import Component from "@glimmer/component"
import { calendar, type CalendarGridCell } from "@ui-sdk/core/calendar"
import type { PrimitiveHandle } from "../use-primitive"
import CalendarWeek, { type CalendarWeekYield } from "./calendar-week.gts"

/** The weeks of the grid's month, a row each, with a day in each cell. A block renders once per shown cell and gets its `cell` and `Day`. A cell that shows nothing stays an empty cell. */
class CalendarWeeks extends Component<{
  Element: HTMLTableSectionElement
  Args: {
    handle: PrimitiveHandle<typeof calendar>
    offset?: number
    weeks: CalendarGridCell[][]
  }
  Blocks: { default: [CalendarWeekYield] }
}> {
  <template>
    <tbody ...attributes>
      {{~#each @weeks as |week index|~}}
        {{~#if (has-block)~}}
          <CalendarWeek
            @handle={{@handle}}
            @offset={{@offset}}
            @index={{index}}
            @week={{week}}
            @custom={{true}}
            as |day|
          >{{yield day}}</CalendarWeek>
        {{~else~}}
          <CalendarWeek
            @handle={{@handle}}
            @offset={{@offset}}
            @index={{index}}
            @week={{week}}
          />
        {{~/if~}}
      {{~/each~}}
    </tbody>
  </template>
}

export default CalendarWeeks
