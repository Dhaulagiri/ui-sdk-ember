import { hash } from "@ember/helper"
import type { WithBoundArgs } from "@glint/template"
import Component from "@glimmer/component"
import { tree } from "@ui-sdk/core/tree"
import { usePart, type RootYield } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import TreeItem from "./tree-item.gts"
import TreeItems from "./tree-items.gts"

/**
 * A hierarchy of items, with arrow-key navigation, expansion, selection and
 * checking. Takes Tree's options as arguments, and yields its parts. Without
 * a block, a data tree renders its `@items`.
 */
class Tree extends Component<{
  Element: HTMLDivElement
  Args: Record<string, unknown> & {
    /** The items as data. */
    items?: unknown[]
    /** Reads and sets the tree from anywhere. */
    controller?: object
    render?: boolean
  }
  Blocks: {
    default: [
      RootYield<typeof tree> & {
        Item: WithBoundArgs<typeof TreeItem, "handle">
        Items: WithBoundArgs<typeof TreeItems, "handle">
      },
    ]
  }
}> {
  handle = usePrimitive(this, tree)
  root = usePart(this, () => this.handle, "root")

  get data() {
    this.args.items
    this.args.paths
    return this.handle.api.internal.items()
  }

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        Item=(component TreeItem handle=this.handle)
        Items=(component TreeItems handle=this.handle)
      )
      as |t|
    }}
      {{#if @render}}
        {{yield t}}
      {{else}}
        <div ...attributes {{this.root.modifier}}>
          {{~#if (has-block)}}{{yield t}}{{else if this.data}}<TreeItems
              @handle={{this.handle}}
              @items={{this.data}}
            />{{/if~}}
        </div>
      {{/if}}
    {{/let}}
  </template>
}

export default Tree
