import Component from "@glimmer/component"
import { calendar } from "@ui-sdk/core/calendar"
import { usePart, type PartSignature } from "../use-part"

/** A weekday's column header. Shows its name in `weekdayFormat` unless it has content. */
class CalendarWeekday extends Component<
  PartSignature<
    typeof calendar,
    "weekday",
    HTMLTableCellElement,
    { index: number; offset?: number }
  >
> {
  part = usePart(
    this,
    () => this.args.handle,
    "weekday",
    () => ({
      index: this.args.index,
      id: `${this.args.offset ?? 0}-${this.args.index}`,
    })
  )

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <th scope="col" ...attributes {{this.part.modifier}}>
        {{~#if (has-block)}}{{yield
            this.part.yielded
          }}{{else}}{{this.part.state.label}}{{/if~}}
      </th>
    {{/if}}
  </template>
}

export default CalendarWeekday
