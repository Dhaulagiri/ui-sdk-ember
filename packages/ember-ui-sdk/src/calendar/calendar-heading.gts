import Component from "@glimmer/component"
import { calendar } from "@ui-sdk/core/calendar"
import { usePart, type PartSignature } from "../use-part"

/** The months shown, like "October 2026". Screen readers hear it change. */
class CalendarHeading extends Component<
  PartSignature<typeof calendar, "heading", HTMLHeadingElement>
> {
  part = usePart(this, () => this.args.handle, "heading")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <h2 ...attributes {{this.part.modifier}}>
        {{~#if (has-block)}}{{yield
            this.part.yielded
          }}{{else}}{{this.part.state.label}}{{/if~}}
      </h2>
    {{/if}}
  </template>
}

export default CalendarHeading
