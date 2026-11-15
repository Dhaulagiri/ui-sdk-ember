import { registerDestructor } from "@ember/destroyable"
import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { tree } from "@ui-sdk/core/tree"
import { usePart, type PartSignature } from "../use-part"
import TreeItem from "./tree-item.gts"
import TreeItems from "./tree-items.gts"
import type { TreeItemContext } from "./tree-item.gts"

/** A branch's children. Rendered while the branch is expanded or animating closed. Yields an `Item` and `Items` for the children. */
class TreeGroup extends Component<
  PartSignature<typeof tree, "group", HTMLDivElement, { item: TreeItemContext }>
> {
  part = usePart(
    this,
    () => this.args.handle,
    "group",
    () => ({
      value: this.args.item.value,
    })
  )

  constructor(owner: Owner, args: TreeGroup["args"]) {
    super(owner, args)
    const { item } = args
    item.join()
    registerDestructor(this, () => item.leave())
  }

  <template>
    {{#if this.part.present}}
      {{#let
        (hash
          part=this.part.modifier
          state=this.part.state
          Item=(component TreeItem handle=@handle parent=@item.value)
          Items=(component TreeItems handle=@handle parent=@item.value)
        )
        as |group|
      }}
        {{#if @render}}
          {{yield group}}
        {{else}}
          <div ...attributes {{this.part.modifier}}>{{yield group}}</div>
        {{/if}}
      {{/let}}
    {{/if}}
  </template>
}

export default TreeGroup
