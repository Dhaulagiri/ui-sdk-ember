import Component from "@glimmer/component"
import type { tree, TreeItemData } from "@ui-sdk/core/tree"
import type { PrimitiveHandle } from "../use-primitive"
import TreeItem from "./tree-item.gts"

/** Renders data items. Used by data trees, and available for custom layouts. */
class TreeItems extends Component<{
  Args: {
    handle: PrimitiveHandle<typeof tree>
    items: TreeItemData[]
    parent?: string | null
    checkable?: boolean
  }
}> {
  get checkable() {
    return this.args.checkable ?? this.args.handle.state.checkable
  }

  isBranch = (item: TreeItemData) => item.children !== undefined

  <template>
    {{#each @items key="value" as |item|}}
      <TreeItem
        @handle={{@handle}}
        @parent={{@parent}}
        @value={{item.value}}
        @branch={{this.isBranch item}}
        @disabled={{item.disabled}}
        as |i|
      >
        {{#if this.checkable}}<i.Checkbox />{{/if}}
        {{#if item.href}}
          <i.Label @render={{true}} as |l|><a
              href={{item.href}}
              {{l.part}}
            >{{item.label}}</a></i.Label>
        {{else}}
          <i.Label>{{item.label}}</i.Label>
        {{/if}}
        {{#if item.children}}
          <i.Group as |g|><g.Items @items={{item.children}} /></i.Group>
        {{/if}}
      </TreeItem>
    {{/each}}
  </template>
}

export default TreeItems
