import Component from "@glimmer/component"
import { slider } from "@ui-sdk/core/slider"
import { usePart, type PartSignature } from "../use-part"

/** Where presses land. A press on the track moves the nearest thumb there. */
class SliderControl extends Component<
  PartSignature<typeof slider, "control", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "control")

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

export default SliderControl
