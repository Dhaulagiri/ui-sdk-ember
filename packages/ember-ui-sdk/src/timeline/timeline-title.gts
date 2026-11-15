import Component from "@glimmer/component"
import { timeline } from "@ui-sdk/core/timeline"
import { usePart, type PartSignature } from "../use-part"

/** What happened. It names its event. */
class TimelineTitle extends Component<
  PartSignature<typeof timeline, "title", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "title")

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

export default TimelineTitle
