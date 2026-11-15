import Component from "@glimmer/component"
import { waterfall } from "@ui-sdk/core/waterfall"
import { usePart, type PartSignature } from "../use-part"

/** The cell on the time axis, which screen readers hear as the span's start and duration. */
class WaterfallBar extends Component<
  PartSignature<typeof waterfall, "bar", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "bar")

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

export default WaterfallBar
