import Component from "@glimmer/component"
import { calendar } from "@ui-sdk/core/calendar"
import { usePart } from "../use-part"
import type { PrimitiveHandle } from "../use-primitive"
import CalendarWeekday from "./calendar-weekday.gts"

/** The header row of weekday names, a weekday in each column. A block renders once per weekday and gets its `Weekday`. */
class CalendarWeekdays extends Component<{
  Element: HTMLTableSectionElement
  Args: {
    handle: PrimitiveHandle<typeof calendar>
    offset?: number
    weekdays: unknown[]
  }
  Blocks: { default: [Record<string, any>] }
}> {
  row = usePart(
    this,
    () => this.args.handle,
    "weekdays",
    () => ({
      id: String(this.args.offset ?? 0),
    })
  )

  <template>
    <thead ...attributes>
      <tr {{this.row.modifier}}>
        {{~#each @weekdays key="@index" as |_weekday index|~}}
          {{~#if (has-block)~}}
            {{yield
              (component
                CalendarWeekday handle=@handle offset=@offset index=index
              )
            }}
          {{~else~}}
            <CalendarWeekday
              @handle={{@handle}}
              @offset={{@offset}}
              @index={{index}}
            />
          {{~/if~}}
        {{~/each~}}
      </tr>
    </thead>
  </template>
}

export default CalendarWeekdays
