import Component from "@glimmer/component"
import { timeline } from "@ui-sdk/core/timeline"
import { usePart, type PartSignature } from "../use-part"

/** The line between its event's marker and the next one. Hidden from assistive technology. */
class TimelineConnector extends Component<
  PartSignature<typeof timeline, "connector", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "connector")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <div ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</div>
    {{/if}}
  </template>
}

export default TimelineConnector
