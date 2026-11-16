import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { htmlSafe } from "@ember/template"
import { tracked } from "@glimmer/tracking"
import { ChevronRight } from "lucide"
import { Tree, visibleTreeRows } from "ember-ui-sdk/tree"
import { icon } from "../../../shared/ember/icon"

const items = Array.from({ length: 100 }, (_, folder) => ({
  value: `folder-${folder + 1}`,
  label: `Folder ${folder + 1}`,
  children: Array.from({ length: 100 }, (_, file) => ({
    value: `folder-${folder + 1}/file-${file + 1}`,
    label: `File ${file + 1}.txt`,
  })),
}))

const row = 32
const height = 288

export default class Virtualized extends Component {
  items = items
  @tracked scrollTop = 0
  @tracked expanded = ["folder-1"]

  get rows() {
    return visibleTreeRows(this.items, this.expanded)
  }

  get start() {
    return Math.max(0, Math.floor(this.scrollTop / row) - 4)
  }

  get end() {
    return Math.min(
      this.rows.length,
      Math.ceil((this.scrollTop + height) / row) + 4
    )
  }

  get visibleRows() {
    return this.rows.slice(this.start, this.end)
  }

  get treeStyle() {
    return htmlSafe(`height: ${this.rows.length * row}px`)
  }

  topOf = (index: number) => htmlSafe(`top: ${index * row}px`)

  scrolled = (event: Event) => {
    this.scrollTop = (event.currentTarget as HTMLDivElement).scrollTop
  }

  onExpandedChange = (next: string[]) => {
    this.expanded = next
  }

  onHighlight = (_value: string, { index }: { index: number }) => {
    const el = document.querySelector<HTMLDivElement>("#virtualized-scroller")
    if (!el) {
      return
    }
    const top = index * row
    if (top < el.scrollTop) {
      el.scrollTop = top
    } else if (top + row > el.scrollTop + el.clientHeight - 10) {
      el.scrollTop = top + row - el.clientHeight + 10
    }
    this.scrollTop = el.scrollTop
  }

  <template>
    <div
      id="virtualized-scroller"
      data-slot="scroll"
      {{on "scroll" this.scrolled}}
    >
      <Tree
        aria-label="Archive"
        @items={{this.items}}
        @expanded={{this.expanded}}
        @onExpandedChange={{this.onExpandedChange}}
        @onHighlight={{this.onHighlight}}
        style={{this.treeStyle}}
        as |t|
      >
        {{#each this.visibleRows key="item.value" as |entry|}}
          <t.Item
            @value={{entry.item.value}}
            style={{this.topOf entry.index}}
            as |i|
          >
            <i.Label>
              {{#if entry.item.children}}
                <i.Indicator>{{icon ChevronRight}}</i.Indicator>
              {{/if}}
              {{entry.item.label}}
            </i.Label>
          </t.Item>
        {{/each}}
      </Tree>
    </div>
  </template>
}
