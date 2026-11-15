import Component from "@glimmer/component"
import { calendar } from "@ui-sdk/core/calendar"
import { usePart, type PartSignature } from "../use-part"

/** Shows the month after. Named "Next month"; pass `aria-label` in another language. */
class CalendarNext extends Component<
  PartSignature<typeof calendar, "next", HTMLButtonElement>
> {
  part = usePart(this, () => this.args.handle, "next")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <button ...attributes {{this.part.modifier}}>
        {{~#if (has-block)}}{{yield this.part.yielded}}{{else}}›{{/if~}}
      </button>
    {{/if}}
  </template>
}

export default CalendarNext
