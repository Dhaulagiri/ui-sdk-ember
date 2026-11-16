import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { ChevronRight } from "lucide"
import {
  createWaterfallController,
  visibleWaterfallRows,
  Waterfall,
} from "ember-ui-sdk/waterfall"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const trace = [
  {
    value: "checkout",
    label: "POST /checkout",
    start: 0,
    duration: 920,
    children: [
      { value: "auth", label: "auth.verify", start: 12, duration: 64 },
      {
        value: "cart",
        label: "cart.load",
        start: 80,
        duration: 310,
        children: [
          {
            value: "cart-db",
            label: "db.query carts",
            start: 96,
            duration: 140,
          },
          {
            value: "prices",
            label: "pricing.quote",
            start: 240,
            duration: 136,
          },
        ],
      },
      {
        value: "payment",
        label: "payments.charge",
        start: 400,
        duration: 470,
        children: [
          { value: "fraud", label: "fraud.score", start: 410, duration: 120 },
          {
            value: "gateway",
            label: "gateway.capture",
            start: 540,
            duration: 310,
          },
        ],
      },
      { value: "email", label: "email.enqueue", start: 880, duration: 30 },
    ],
  },
]

const format = { style: "unit", unit: "millisecond", unitDisplay: "narrow" }

export default class Trace extends Component {
  log = useLog(this)
  spans = createWaterfallController()
  trace = trace
  format = format
  @tracked expanded = ["checkout"]
  @tracked value: string | null = null

  get rows() {
    return visibleWaterfallRows(this.trace, this.expanded)
  }

  onValueChange = (next: string | null) => {
    this.value = next
    this.log(`Selected ${next}`)
  }

  onExpandedChange = (next: string[]) => {
    this.expanded = next
  }

  expandAll = () => {
    this.spans.expandAll()
  }

  collapseAll = () => {
    this.spans.collapseAll()
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.expandAll}}>Expand All</button>
        <button type="button" {{on "click" this.collapseAll}}>Collapse All</button>
      </div>
      <Waterfall
        aria-label="Checkout trace"
        @items={{this.trace}}
        @controller={{this.spans}}
        @expanded={{this.expanded}}
        @onExpandedChange={{this.onExpandedChange}}
        @value={{this.value}}
        @onValueChange={{this.onValueChange}}
        @format={{this.format}}
        as |w|
      >
        <w.HeaderRow>
          <w.ColumnHeader>Span</w.ColumnHeader>
          <w.ColumnHeader aria-label="Timeline">
            <w.Axis />
          </w.ColumnHeader>
        </w.HeaderRow>
        {{#each this.rows key="@index" as |entry|}}
          <w.Row @value={{entry.item.value}} as |row|>
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
