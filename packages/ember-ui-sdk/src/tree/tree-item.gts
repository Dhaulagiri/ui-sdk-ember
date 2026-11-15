import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { tree } from "@ui-sdk/core/tree"
import { usePart, type PartSignature } from "../use-part"
import TreeGroup from "./tree-group.gts"
import TreeItemCheckbox from "./tree-item-checkbox.gts"
import TreeItemIndicator from "./tree-item-indicator.gts"
import TreeItemLabel from "./tree-item-label.gts"

class TreeItemContext {
  groups = 0
  @tracked revision = 0

  constructor(readonly value: string) {}

  get branched() {
    this.revision
    return this.groups > 0 || undefined
  }

  join() {
    this.groups++
    queueMicrotask(() => this.revision++)
  }

  leave() {
    this.groups--
    queueMicrotask(() => this.revision++)
  }
}

/**
 * An item. Put its text in a `Label` and its children in a `Group`, which
 * makes it a branch. Set `@branch` for one whose children load later, or
 * whose group is inside a component of your own. Yields its `Indicator`,
 * `Checkbox`, `Label` and `Group`.
 */
class TreeItem extends Component<
  PartSignature<typeof tree, "item", HTMLDivElement, { parent?: string | null }>
> {
  context = new TreeItemContext(this.args.value as string)
  part = usePart(
    this,
    () => this.args.handle,
    "item",
    () => ({
      parent: this.args.parent ?? null,
      branch: this.args.branch ?? this.context.branched,
    })
  )

  <template>
    {{#let
      (hash
        part=this.part.modifier
        state=this.part.state
        Indicator=(component
          TreeItemIndicator
          handle=@handle
          value=@value
          grouped=this.context.revision
        )
        Checkbox=(component
          TreeItemCheckbox
          handle=@handle
          value=@value
          grouped=this.context.revision
        )
        Label=(component
          TreeItemLabel
          handle=@handle
          value=@value
          grouped=this.context.revision
        )
        Group=(component TreeGroup handle=@handle item=this.context)
      )
      as |item|
    }}
      {{#if @render}}
        {{yield item}}
      {{else}}
        <div ...attributes {{this.part.modifier}}>{{yield item}}</div>
      {{/if}}
    {{/let}}
  </template>
}

export default TreeItem
export type { TreeItemContext }
