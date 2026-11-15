import Component from "@glimmer/component"
import { waterfall } from "@ui-sdk/core/waterfall"
import { usePart, type PartSignature } from "../use-part"

/** The row of column headers, above the rows. */
class WaterfallHeaderRow extends Component<
  PartSignature<typeof waterfall, "header-row", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "header-row")

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

export default WaterfallHeaderRow
