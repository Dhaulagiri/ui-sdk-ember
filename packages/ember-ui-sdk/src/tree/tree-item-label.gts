import Component from "@glimmer/component"
import { tree } from "@ui-sdk/core/tree"
import { usePart, type PartSignature } from "../use-part"

/** The item's text, which names it. Render it as a link to make the item one. */
class TreeItemLabel extends Component<
  PartSignature<typeof tree, "label", HTMLSpanElement, { grouped?: number }>
> {
  part = usePart(
    this,
    () => this.args.handle,
    "label",
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

export default TreeItemLabel
