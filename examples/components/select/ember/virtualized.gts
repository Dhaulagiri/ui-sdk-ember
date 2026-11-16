import { on } from "@ember/modifier"
import { htmlSafe } from "@ember/template"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { ChevronDown } from "lucide"
import { Field } from "ember-ui-sdk/field"
import { Select } from "ember-ui-sdk/select"
import { icon } from "../../../shared/ember/icon"

type Item = { value: string; label: string }

const manyItems = Array.from({ length: 10_000 }, (_, index) => ({
  value: `item-${index + 1}`,
  label: `Item ${index + 1}`,
}))

function visibleRows(
  scrollTop: number,
  height: number,
  count: number,
  row: number
) {
  const start = Math.max(0, Math.floor(scrollTop / row) - 4)
  const end = Math.min(count, Math.ceil((scrollTop + height) / row) + 4)
  return { start, end }
}

function scrollForRow(
  index: number,
  scrollTop: number,
  height: number,
  row: number
) {
  const top = index * row
  if (top < scrollTop) {
    return top
  }
  if (top + row > scrollTop + height) {
    return top + row - height
  }
  return scrollTop
}

const row = 32
const height = 288

const scrollerStyle = htmlSafe(`height: ${height}px`)
const listStyle = (items: Item[]) => htmlSafe(`height: ${items.length * row}px`)
const rowStyle = (index: number) =>
  htmlSafe(`top: ${index * row}px; height: ${row}px`)

export default class Virtualized extends Component {
  @tracked scrollTop = 0
  scroller: HTMLElement | null = null

  visible = (items: Item[]) => {
    const { start, end } = visibleRows(
      this.scrollTop,
      height,
      items.length,
      row
    )
    return items
      .slice(start, end)
      .map((item, offset) => ({ item, index: start + offset }))
  }

  onScroll = (event: Event) => {
    this.scroller = event.currentTarget as HTMLElement
    this.scrollTop = this.scroller.scrollTop
  }

  onHighlight = (_: unknown, { index }: { index: number }) => {
    const el = this.scroller ?? document.getElementById("select-virtual-rows")
    if (el && index >= 0) {
      el.scrollTop = scrollForRow(index, el.scrollTop, el.clientHeight, row)
    }
  }

  <template>
    <Field as |f|>
      <f.Label>Item</f.Label>
      <Select
        @items={{manyItems}}
        @placeholder="Select an item"
        @onHighlight={{this.onHighlight}}
        as |s|
      >
        <s.Trigger @field={{f.field}}>
          <s.Value />
          {{icon ChevronDown}}
        </s.Trigger>
        <s.Content>
          <div
            id="select-virtual-rows"
            style={{scrollerStyle}}
            {{on "scroll" this.onScroll}}
          >
            <s.List as |list|>
              <div style={{listStyle list.state.items}}>
                {{#each (this.visible list.state.items) key="index" as |entry|}}
                  <s.Item
                    @value={{entry.item.value}}
                    @label={{entry.item.label}}
                    @index={{entry.index}}
                    style={{rowStyle entry.index}}
                  >
                    {{entry.item.label}}
                  </s.Item>
                {{/each}}
              </div>
            </s.List>
          </div>
        </s.Content>
      </Select>
    </Field>
  </template>
}
