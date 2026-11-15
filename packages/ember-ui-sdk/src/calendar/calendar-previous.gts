import Component from "@glimmer/component"
import { calendar } from "@ui-sdk/core/calendar"
import { usePart, type PartSignature } from "../use-part"

/** Shows the month before. Named "Previous month"; pass `aria-label` in another language. */
class CalendarPrevious extends Component<
  PartSignature<typeof calendar, "previous", HTMLButtonElement>
> {
  part = usePart(this, () => this.args.handle, "previous")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <button ...attributes {{this.part.modifier}}>
        {{~#if (has-block)}}{{yield this.part.yielded}}{{else}}‹{{/if~}}
      </button>
    {{/if}}
  </template>
}

export default CalendarPrevious
