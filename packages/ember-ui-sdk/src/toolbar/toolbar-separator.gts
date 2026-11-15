import Component from "@glimmer/component"
import { toolbar } from "@ui-sdk/core/toolbar"
import { usePart, type PartSignature } from "../use-part"

/** A line between groups of items. */
class ToolbarSeparator extends Component<
  PartSignature<typeof toolbar, "separator", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "separator")

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

export default ToolbarSeparator
