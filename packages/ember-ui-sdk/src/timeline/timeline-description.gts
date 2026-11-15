import Component from "@glimmer/component"
import { timeline } from "@ui-sdk/core/timeline"
import { usePart, type PartSignature } from "../use-part"

/** More about its event. It describes the event. */
class TimelineDescription extends Component<
  PartSignature<typeof timeline, "description", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "description")

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

export default TimelineDescription
