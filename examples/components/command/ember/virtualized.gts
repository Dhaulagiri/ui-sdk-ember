import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { htmlSafe } from "@ember/template"
import { tracked } from "@glimmer/tracking"
import { Command } from "ember-ui-sdk/command"

const commands = Array.from({ length: 10_000 }, (_, index) => ({
  value: `command-${index + 1}`,
  label: `Command ${index + 1}`,
}))

const row = 32
const height = 256

export default class Virtualized extends Component {
  commands = commands
  @tracked scrollTop = 0

  onValueChange = (_value: string | null, { index }: { index: number }) => {
    const el = document.querySelector<HTMLDivElement>("#virtualized-scroller")
    if (!el || index < 0) {
      return
    }
    const top = index * row
    if (top < el.scrollTop) {
      el.scrollTop = top
    } else if (top + row > el.scrollTop + el.clientHeight) {
      el.scrollTop = top + row - el.clientHeight
    }
  }

  scrolled = (event: Event) => {
    this.scrollTop = (event.currentTarget as HTMLDivElement).scrollTop
  }

  visible = (items: typeof commands) => {
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

  topOf = (index: number) => htmlSafe(`top: ${index * row}px`)

  <template>
    <Command
      @items={{this.commands}}
      @onValueChange={{this.onValueChange}}
      as |c|
    >
      <c.Input
        aria-label="Search 10,000 commands"
        placeholder="Search 10,000 commands…"
      />
      <div id="virtualized-scroller" {{on "scroll" this.scrolled}}>
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
                style={{this.topOf entry.index}}
              >
                {{entry.item.label}}
              </c.Item>
            {{/each}}
          </div>
        </c.List>
      </div>
    </Command>
  </template>
}
