import Component from "@glimmer/component"
import { slider } from "@ui-sdk/core/slider"
import { usePart, type PartSignature } from "../use-part"

/** The rail the thumbs move along. Positions are percentages of it. */
class SliderTrack extends Component<
  PartSignature<typeof slider, "track", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "track")

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

export default SliderTrack
