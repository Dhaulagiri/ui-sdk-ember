import Component from "@glimmer/component"
import { tree } from "@ui-sdk/core/tree"
import { usePart, type PartSignature } from "../use-part"

/** The item's checkbox, with `checkable`. Screen readers hear the item's checked state instead. */
class TreeItemCheckbox extends Component<
  PartSignature<typeof tree, "checkbox", HTMLSpanElement, { grouped?: number }>
> {
  part = usePart(
    this,
    () => this.args.handle,
    "checkbox",
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

export default TreeItemCheckbox
