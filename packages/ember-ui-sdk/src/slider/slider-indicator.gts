import Component from "@glimmer/component"
import { slider } from "@ui-sdk/core/slider"
import { usePart, type PartSignature } from "../use-part"

/** The filled part of the track: up to a single thumb, or between a range's thumbs. */
class SliderIndicator extends Component<
  PartSignature<typeof slider, "indicator", HTMLDivElement>
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

export default SliderIndicator
