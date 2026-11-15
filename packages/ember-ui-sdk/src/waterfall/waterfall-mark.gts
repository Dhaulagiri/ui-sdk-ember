import Component from "@glimmer/component"
import { waterfall } from "@ui-sdk/core/waterfall"
import { usePart, type PartSignature } from "../use-part"

/** A moment across every row, like DOMContentLoaded, placed by `--waterfall-mark`. */
class WaterfallMark extends Component<
  PartSignature<typeof waterfall, "mark", HTMLSpanElement>
> {
  part = usePart(this, () => this.args.handle, "mark")

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

export default WaterfallMark
