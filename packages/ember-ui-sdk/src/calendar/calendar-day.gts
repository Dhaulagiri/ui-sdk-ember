import Component from "@glimmer/component"
import { calendar } from "@ui-sdk/core/calendar"
import { usePart, type PartSignature } from "../use-part"

/** A day. Shows the day of the month unless it has content; arrow keys move between days. */
class CalendarDay extends Component<
  PartSignature<
    typeof calendar,
    "day",
    HTMLTableCellElement,
    { offset?: number }
  >
> {
  part = usePart(
    this,
    () => this.args.handle,
    "day",
    () => ({
      offset: this.args.offset ?? 0,
    })
  )

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <td ...attributes {{this.part.modifier}}>
        {{~#if (has-block)}}{{yield
            this.part.yielded
          }}{{else}}{{this.part.state.label}}{{/if~}}
      </td>
    {{/if}}
  </template>
}

export default CalendarDay
