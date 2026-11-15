import Component from "@glimmer/component"
import { waterfall } from "@ui-sdk/core/waterfall"
import { usePart, type PartSignature } from "../use-part"

/** The arrow that expands and collapses a span with children. */
class WaterfallIndicator extends Component<
  PartSignature<typeof waterfall, "indicator", HTMLSpanElement>
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

export default WaterfallIndicator
