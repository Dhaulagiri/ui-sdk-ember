import Component from "@glimmer/component"
import { tree } from "@ui-sdk/core/tree"
import { usePart, type PartSignature } from "../use-part"

/** The arrow that expands and collapses a branch. Alt or Option expands everything in it. */
class TreeItemIndicator extends Component<
  PartSignature<typeof tree, "indicator", HTMLSpanElement, { grouped?: number }>
> {
  part = usePart(
    this,
    () => this.args.handle,
    "indicator",
    () => {
      this.args.grouped
      return { value: this.args.value }
    }
  )

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

export default TreeItemIndicator
