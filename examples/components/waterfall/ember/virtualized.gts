import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { ChevronRight } from "lucide"
import { visibleWaterfallRows, Waterfall } from "ember-ui-sdk/waterfall"
import { icon } from "../../../shared/ember/icon"

const trace = Array.from({ length: 2000 }, (_, job) => ({
  value: `job-${job + 1}`,
  label: `job ${job + 1}`,
  start: job * 4,
  duration: 60,
  children: Array.from({ length: 4 }, (_, step) => ({
    value: `job-${job + 1}/step-${step + 1}`,
    label: `step ${step + 1}`,
    start: job * 4 + step * 15,
    duration: 15,
  })),
}))

const row = 32
const height = 288
const range: [number, number] = [0, 400]

const topOf = (index: number) => index * row
const rowIndexOf = (index: number) => index + 1

export default class Virtualized extends Component {
  trace = trace
  row = row
  range = range
  @tracked scrollTop = 0
  @tracked expanded = ["job-1"]

  get rows() {
    return visibleWaterfallRows(this.trace, this.expanded)
  }

  get visible() {
    const start = Math.max(0, Math.floor(this.scrollTop / row) - 4)
    const end = Math.min(
      this.rows.length,
      Math.ceil((this.scrollTop + height) / row) + 4
    )
    return this.rows.slice(start, end)
  }

  get totalHeight() {
    return `height: ${this.rows.length * row}px`
  }

  topOf = topOf

  rowIndexOf = rowIndexOf

  get rowCount() {
    return this.rows.length
  }

  onScroll = (event: Event) => {
    this.scrollTop = (event.currentTarget as HTMLElement).scrollTop
  }

  onExpandedChange = (next: string[]) => {
    this.expanded = next
  }

  onHighlight = (_value: string, details: { index: number }) => {
    const el = document.querySelector<HTMLElement>("#virtualized-scroll")
    if (!el) return
    const top = topOf(details.index)
    if (top < el.scrollTop) {
      el.scrollTop = top
    } else if (top + row > el.scrollTop + el.clientHeight) {
      el.scrollTop = top + row - el.clientHeight
    }
    this.scrollTop = el.scrollTop
  }

  <template>
    <div
      id="virtualized-scroll"
      data-slot="scroll"
      {{on "scroll" this.onScroll}}
    >
      <Waterfall
        aria-label="Build trace"
        aria-rowcount={{this.rowCount}}
        @items={{this.trace}}
        @range={{this.range}}
        @expanded={{this.expanded}}
        @onExpandedChange={{this.onExpandedChange}}
        @onHighlight={{this.onHighlight}}
        style={{this.totalHeight}}
        as |w|
      >
        {{#each this.visible key="@index" as |entry|}}
          <w.Row
            @value={{entry.item.value}}
            aria-rowindex={{this.rowIndexOf entry.index}}
            style="top: {{this.topOf entry.index}}px"
            as |row|
          >
            <row.Header>
              {{#if entry.item.children}}
                <row.Indicator>{{icon ChevronRight}}</row.Indicator>
              {{/if}}
              {{entry.item.label}}
            </row.Header>
            <row.Bar />
          </w.Row>
        {{/each}}
      </Waterfall>
    </div>
  </template>
}
