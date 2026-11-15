import Component from "@glimmer/component"
import { waterfall } from "@ui-sdk/core/waterfall"
import { usePart, type PartSignature } from "../use-part"

/** A column's header, like "Name" or "Timeline". */
class WaterfallColumnHeader extends Component<
  PartSignature<typeof waterfall, "column-header", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "column-header")

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

export default WaterfallColumnHeader
