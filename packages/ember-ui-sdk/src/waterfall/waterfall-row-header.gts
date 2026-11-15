import Component from "@glimmer/component"
import { waterfall } from "@ui-sdk/core/waterfall"
import { usePart, type PartSignature } from "../use-part"

/** The cell that names the span. Put the indicator and the span's label in it. */
class WaterfallRowHeader extends Component<
  PartSignature<typeof waterfall, "row-header", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "row-header")

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

export default WaterfallRowHeader
