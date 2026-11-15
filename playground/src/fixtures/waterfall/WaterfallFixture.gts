import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { createWaterfallController, Waterfall } from "ember-ui-sdk/waterfall"
import {
  describeWaterfall,
  flatWaterfall,
  waterfallFixture,
  waterfallOptions,
} from "tests/fixtures/waterfall.ts"

export default class WaterfallFixture extends Component {
  f = waterfallFixture
  controller = createWaterfallController()
  spans = flatWaterfall(waterfallFixture.items)
  options = waterfallOptions()
  @tracked action = ""
  @tracked range = this.options.range

  onValueChange = (value: string | null) =>
    (this.action = describeWaterfall("selected", value))

  onExpandedChange = (expanded: string[], details: { cancel: () => void }) => {
    const { cancel } = this.options
    if (
      cancel &&
      expanded.includes(cancel) &&
      !this.controller.isExpanded(cancel)
    ) {
      return details.cancel()
    }
    this.action = describeWaterfall("expanded", expanded)
  }

  expandAll = () => this.controller.expandAll()
  collapseAll = () => this.controller.collapseAll()
  reveal = () => this.controller.reveal("flags")
  zoom = () => (this.range = [500, 1000])

  <template>
    <div class="fixture">
      <button>Before</button>
      <Waterfall
        aria-label={{this.f.label}}
        @items={{this.f.items}}
        @controller={{this.controller}}
        @range={{this.range}}
        @defaultExpanded={{this.options.defaultExpanded}}
        @defaultValue={{this.options.defaultValue}}
        @onValueChange={{this.onValueChange}}
        @onExpandedChange={{this.onExpandedChange}}
        as |w|
      >
        <w.HeaderRow>
          <w.ColumnHeader>Name</w.ColumnHeader>
          <w.ColumnHeader>Status</w.ColumnHeader>
          <w.ColumnHeader aria-label="Timeline">
            <w.Axis />
            <w.Mark @time={{this.f.mark.time}}>
              {{this.f.mark.label}}
            </w.Mark>
          </w.ColumnHeader>
        </w.HeaderRow>
        {{#each this.spans key="value" as |span|}}
          <w.Row @value={{span.value}} as |row|>
            <row.Header>
              {{#if span.children}}<row.Indicator />{{/if}}
              {{span.label}}
            </row.Header>
            <row.Cell>{{span.status}}</row.Cell>
            <row.Bar />
          </w.Row>
        {{/each}}
      </Waterfall>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
      <button {{on "click" this.expandAll}}>Expand all</button>
      <button {{on "click" this.collapseAll}}>Collapse all</button>
      <button {{on "click" this.reveal}}>Reveal flags</button>
      <button {{on "click" this.zoom}}>Zoom</button>
    </div>
  </template>
}
