import Component from "@glimmer/component"
import { array } from "@ember/helper"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { ChevronRight } from "lucide"
import {
  Waterfall,
  WaterfallTick,
  type WaterfallData,
} from "ember-ui-sdk/waterfall"
import { icon } from "../../../shared/ember/icon"

const trace: WaterfallData = [
  {
    value: "render",
    label: "render /dashboard",
    start: 0,
    duration: 1200,
    children: [
      { value: "session", label: "session", start: 20, duration: 80 },
      { value: "metrics", label: "metrics", start: 110, duration: 640 },
      { value: "alerts", label: "alerts", start: 110, duration: 260 },
      { value: "html", label: "stream html", start: 760, duration: 420 },
    ],
  },
]

const full: [number, number] = [0, 1200]

function zoomed([start, end]: [number, number], factor: number) {
  const center = (start + end) / 2
  const half = Math.min(((end - start) * factor) / 2, full[1] / 2)
  const from = Math.min(Math.max(full[0], center - half), full[1] - half * 2)
  return [from, from + half * 2] as [number, number]
}

const spans = [trace[0], ...trace[0].children!]

export default class Zoom extends Component {
  spans = spans
  full = full
  @tracked range: [number, number] = full

  zoomIn = () => {
    this.range = zoomed(this.range, 0.5)
  }

  zoomOut = () => {
    this.range = zoomed(this.range, 2)
  }

  reset = () => {
    this.range = full
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.zoomIn}}>Zoom In</button>
        <button type="button" {{on "click" this.zoomOut}}>Zoom Out</button>
        <button type="button" {{on "click" this.reset}}>Reset</button>
      </div>
      <Waterfall
        aria-label="Dashboard render"
        @items={{trace}}
        @range={{this.range}}
        @defaultExpanded={{array "render"}}
        @defaultValue="metrics"
        as |w|
      >
        <w.HeaderRow>
          <w.ColumnHeader>Span</w.ColumnHeader>
          <w.ColumnHeader aria-label="Timeline">
            <w.Axis as |axis|>
              {{#each axis.state.ticks key="time" as |tick|}}
                <WaterfallTick
                  @handle={{w.handle}}
                  @time={{tick.time}}
                >{{tick.label}}</WaterfallTick>
              {{/each}}
            </w.Axis>
          </w.ColumnHeader>
        </w.HeaderRow>
        {{#each this.spans key="value" as |span|}}
          <w.Row @value={{span.value}} as |row|>
            <row.Header>
              {{#if span.children}}
                <row.Indicator>{{icon ChevronRight}}</row.Indicator>
              {{/if}}
              {{span.label}}
            </row.Header>
            <row.Bar />
          </w.Row>
        {{/each}}
      </Waterfall>
    </div>
  </template>
}
