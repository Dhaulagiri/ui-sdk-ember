import Component from "@glimmer/component"
import { waterfall } from "@ui-sdk/core/waterfall"
import { usePart, type PartSignature } from "../use-part"

/** A cell of your own, like a status or a size. */
class WaterfallCell extends Component<
  PartSignature<typeof waterfall, "cell", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "cell")

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

export default WaterfallCell
