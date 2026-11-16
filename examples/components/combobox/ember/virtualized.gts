import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { htmlSafe } from "@ember/template"
import { tracked } from "@glimmer/tracking"
import { Combobox } from "ember-ui-sdk/combobox"
import { ChevronDown } from "lucide"
import { attach } from "ember-ui-sdk/primitive"
import { icon } from "../../../shared/ember/icon"

const manyItems = Array.from({ length: 10_000 }, (_, index) => ({
  value: `item-${index + 1}`,
  label: `Item ${index + 1}`,
}))

const row = 32
const height = 288

function scrollForRow(
  index: number,
  scrollTop: number,
  viewport: number,
  size: number
) {
  const top = index * size
  if (top < scrollTop) {
    return top
  }
  if (top + size > scrollTop + viewport) {
    return top + size - viewport
  }
  return scrollTop
}

export default class Virtualized extends Component {
  items = manyItems
  scroller: HTMLElement | null = null
  @tracked scrollTop = 0

  setScroller = (element: HTMLElement) => {
    this.scroller = element
  }

  onHighlight = (_value: unknown, { index }: { index: number }) => {
    const el = this.scroller
    if (el && index >= 0) {
      el.scrollTop = scrollForRow(index, el.scrollTop, el.clientHeight, row)
    }
  }

  onScroll = (event: Event) => {
    this.scrollTop = (event.currentTarget as HTMLElement).scrollTop
  }

  visible = (items: typeof manyItems) => {
    const start = Math.max(0, Math.floor(this.scrollTop / row) - 4)
    const end = Math.min(
      items.length,
      Math.ceil((this.scrollTop + height) / row) + 4
    )
    return items
      .slice(start, end)
      .map((item, offset) => ({ item, index: start + offset }))
  }

  heightOf = (count: number) => htmlSafe(`height: ${count * row}px`)

  rowStyle = (index: number) =>
    htmlSafe(`top: ${index * row}px; height: ${row}px`)

  <template>
    <Combobox @items={{this.items}} @onHighlight={{this.onHighlight}} as |c|>
      <div data-slot="stack">
        <c.Label>Item</c.Label>
        <div data-slot="row">
          <c.Input placeholder="Search 10,000 items…" />
          <c.Trigger aria-label="Show items">
            {{icon ChevronDown}}
          </c.Trigger>
        </div>
      </div>
      <c.Content>
        <c.Empty>No items found.</c.Empty>
        <div {{attach this.setScroller}} {{on "scroll" this.onScroll}}>
          <c.List as |list|>
            <div style={{this.heightOf list.state.items.length}}>
              {{#each
                (this.visible list.state.items) key="item.value"
                as |entry|
              }}
                <c.Item
                  @value={{entry.item.value}}
                  @label={{entry.item.label}}
                  @index={{entry.index}}
                  style={{this.rowStyle entry.index}}
                >
                  {{entry.item.label}}
                </c.Item>
              {{/each}}
            </div>
          </c.List>
        </div>
      </c.Content>
    </Combobox>
  </template>
}
