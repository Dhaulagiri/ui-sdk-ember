import Component from "@glimmer/component"
import { meter } from "@ui-sdk/core/meter"
import { usePart, type PartSignature } from "../use-part"

/** The filled part of the track, as wide as the value. */
class MeterIndicator extends Component<
  PartSignature<typeof meter, "indicator", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "indicator")

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

export default MeterIndicator
