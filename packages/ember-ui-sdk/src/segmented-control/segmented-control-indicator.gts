import Component from "@glimmer/component"
import { segmentedControl } from "@ui-sdk/core/segmented-control"
import { usePart, type PartSignature } from "../use-part"

/** Sits behind the checked item. Its box comes from the `--segmented-control-indicator-*` variables, measured from the root. */
class SegmentedControlIndicator extends Component<
  PartSignature<typeof segmentedControl, "indicator", HTMLSpanElement>
> {
  part = usePart(this, () => this.args.handle, "indicator")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <span ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</span>
    {{/if}}
  </template>
}

export default SegmentedControlIndicator
