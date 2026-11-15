import Component from "@glimmer/component"
import { timeline } from "@ui-sdk/core/timeline"
import { usePart, type PartSignature } from "../use-part"

/** The dot or icon that marks its event on the line. Hidden from assistive technology. */
class TimelineMarker extends Component<
  PartSignature<typeof timeline, "marker", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "marker")

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

export default TimelineMarker
