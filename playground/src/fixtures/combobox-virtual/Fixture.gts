import type { ModifierLike } from "@glint/template"
import { capabilities, on, setModifierManager } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Combobox, type ListData } from "ember-ui-sdk/combobox"
import { longItems, scrollForRow, visibleRows } from "tests/fixtures/select.ts"

const items = longItems()
const row = 32
const height = 240

const ref = setModifierManager(
  () => ({
    capabilities: capabilities("3.22", { disableAutoTracking: true }),
    createModifier: () => ({}),
    installModifier: (
      _: object,
      el: Element,
      { positional }: { positional: unknown[] }
    ) => (positional[0] as (el: Element) => void)(el),
    updateModifier: () => {},
    destroyModifier: () => {},
  }),
  function () {} as unknown as ModifierLike<{
    Element: Element
    Args: { Positional: [(el: any) => unknown] }
  }>
)

export default class Fixture extends Component {
  items = items
  height = height
  scroller: HTMLElement | null = null
  @tracked scrollTop = 0

  setScroller = (el: HTMLElement) => (this.scroller = el)
  onScroll = (event: Event) => {
    this.scrollTop = (event.currentTarget as HTMLElement).scrollTop
  }

  onHighlight = (_: unknown, { index }: { index: number }) => {
    const el = this.scroller
    if (el && index >= 0) {
      el.scrollTop = scrollForRow(index, el.scrollTop, height, row)
    }
  }

  total = (visible: readonly unknown[]) =>
    `height: ${visible.length * row}px; position: relative`

  rows = (visible: ListData<unknown>) => {
    const { start, end } = visibleRows(
      this.scrollTop,
      height,
      visible.length,
      row
    )
    return visible.slice(start, end).map((item, offset) => {
      if (
        typeof item !== "object" ||
        !("value" in item) ||
        typeof item.value !== "string"
      ) {
        throw new Error("This fixture expects items with string values")
      }
      return {
        ...item,
        value: item.value,
        index: start + offset,
        style: `position: absolute; top: ${(start + offset) * row}px; height: ${row}px; left: 0; right: 0`,
      }
    })
  }

  <template>
    <div class="fixture">
      <button>Before</button>
      <Combobox @items={{this.items}} @onHighlight={{this.onHighlight}} as |c|>
        <c.Label class="label">Item</c.Label>
        <c.Input class="input" />
        <c.Content class="popup">
          <div
            class="long-list"
            style="height: {{this.height}}px"
            {{ref this.setScroller}}
            {{on "scroll" this.onScroll}}
          >
            <c.List style="position: relative; height: auto" as |list|>
              <div style={{this.total list.state.items}}>
                {{#each (this.rows list.state.items) key="value" as |item|}}
                  <c.Item
                    class="item"
                    @value={{item.value}}
                    @label={{item.label}}
                    @index={{item.index}}
                    style={{item.style}}
                  >{{item.label}}</c.Item>
                {{/each}}
              </div>
            </c.List>
          </div>
        </c.Content>
      </Combobox>
      <button>After</button>
    </div>
  </template>
}
