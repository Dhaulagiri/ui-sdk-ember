import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { createTreeController, Tree } from "ember-ui-sdk/tree"
import { treeOptions } from "tests/fixtures/page.ts"
import { describeTree, treeFixture } from "tests/fixtures/tree.ts"
import TreeFixtureItems from "./TreeFixtureItems.gts"

export default class TreeFixture extends Component<{
  Args: { data?: boolean }
}> {
  f = treeFixture
  controller = createTreeController()
  options = treeOptions()
  @tracked action = ""

  get items() {
    return this.args.data ? treeFixture.items : undefined
  }

  onExpandedChange = (expanded: string[], details: { cancel: () => void }) => {
    const { cancel } = this.options
    if (
      cancel &&
      expanded.includes(cancel) &&
      !this.controller.isExpanded(cancel)
    ) {
      return details.cancel()
    }
    this.action = describeTree("expanded", expanded)
  }

  onValueChange = (value: string | string[] | null) => {
    this.action = describeTree("selected", value)
  }
  onCheckedChange = (checked: string[]) => {
    this.action = describeTree("checked", checked)
  }
  onAction = (value: string) => {
    this.action = describeTree("action", value)
  }
  expandAll = () => this.controller.expandAll()
  collapseAll = () => this.controller.collapseAll()
  reveal = () => this.controller.reveal("dialog.tsx")

  <template>
    <div class="fixture">
      <button>Before</button>
      <Tree
        class="tree"
        aria-label={{this.f.label}}
        @items={{this.items}}
        @controller={{this.controller}}
        @mode={{this.options.mode}}
        @defaultValue={{this.options.defaultValue}}
        @defaultExpanded={{this.options.defaultExpanded}}
        @checkable={{this.options.checkable}}
        @checkStrategy={{this.options.checkStrategy}}
        @current={{this.options.current}}
        @activation={{this.options.activation}}
        @disabled={{this.options.disabled}}
        @keepMounted={{this.options.keepMounted}}
        @hiddenUntilFound={{this.options.hiddenUntilFound}}
        @onValueChange={{this.onValueChange}}
        @onExpandedChange={{this.onExpandedChange}}
        @onCheckedChange={{this.onCheckedChange}}
        @onAction={{this.onAction}}
        as |t|
      >
        <TreeFixtureItems
          @parts={{t}}
          @items={{this.f.items}}
          @checkable={{this.options.checkable}}
        />
      </Tree>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
      <button {{on "click" this.expandAll}}>Expand all</button>
      <button {{on "click" this.collapseAll}}>Collapse all</button>
      <button {{on "click" this.reveal}}>Reveal dialog</button>
    </div>
  </template>
}
