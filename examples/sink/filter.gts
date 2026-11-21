import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { X } from "lucide"
import { SegmentedControl } from "ember-ui-sdk/segmented-control"
import { icon } from "./icon.ts"

type Mode = "any" | "all"

const without = (list: string[], name: string) =>
  list.filter((other) => other !== name)

/** The bar that shows the picked tags, matches any or all of them, and clears them. */
export class Filter extends Component<{
  Args: {
    selected: string[]
    onSelectedChange: (names: string[]) => void
    mode: Mode
    onModeChange: (mode: Mode) => void
    shown: number
  }
}> {
  // Clearing keeps the last names on the bar while it slides away.
  last: string[] = []
  get names() {
    if (this.args.selected.length) {
      this.last = this.args.selected
    }
    return this.last
  }

  get count() {
    const { selected, shown } = this.args
    return selected.length ? `${shown} ${shown === 1 ? "tile" : "tiles"}` : ""
  }

  remove = (name: string) =>
    this.args.onSelectedChange(without(this.args.selected, name))

  clear = () => this.args.onSelectedChange([])

  onModeChange = (value: string | null) => {
    if (value) {
      this.args.onModeChange(value as Mode)
    }
  }

  <template>
    <section
      class="filter"
      aria-label="Filters"
      data-open={{if @selected.length ""}}
      inert={{unless @selected.length true}}
    >
      <p class="filter-count" aria-live="polite">{{this.count}}</p>
      <ul class="filter-names">
        {{#each this.names as |name|}}
          <li>
            <button
              type="button"
              class="filter-name"
              aria-label="Remove {{name}}"
              {{on "click" (fn this.remove name)}}
            >{{name}}{{icon X 11}}</button>
          </li>
        {{/each}}
      </ul>
      {{#if (gt @selected.length 1)}}
        <SegmentedControl
          class="filter-mode"
          aria-label="Match"
          @value={{@mode}}
          @onValueChange={{this.onModeChange}}
          as |s|
        >
          <s.Indicator class="filter-mode-indicator" />
          <s.Item @value="any">Any</s.Item>
          <s.Item @value="all">All</s.Item>
        </SegmentedControl>
      {{/if}}
      <button type="button" class="filter-clear" {{on "click" this.clear}}>
        Clear filters
      </button>
    </section>
  </template>
}

const gt = (a: number, b: number) => a > b
