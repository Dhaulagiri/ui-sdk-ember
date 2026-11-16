import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check, ChevronDown } from "lucide"
import { HoverCard } from "ember-ui-sdk/hover-card"
import { Select } from "ember-ui-sdk/select"
import { icon } from "../../../shared/ember/icon"

const sides = [
  { value: "top", label: "Top" },
  { value: "right", label: "Right" },
  { value: "bottom", label: "Bottom" },
  { value: "left", label: "Left" },
]

const aligns = [
  { value: "start", label: "Start" },
  { value: "center", label: "Center" },
  { value: "end", label: "End" },
]

export default class Side extends Component {
  sides = sides
  aligns = aligns
  @tracked side = "bottom"
  @tracked align = "center"

  onSideChange = (next: string | null) => {
    if (next) this.side = next
  }

  onAlignChange = (next: string | null) => {
    if (next) this.align = next
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <Select
          @items={{this.sides}}
          @value={{this.side}}
          @onValueChange={{this.onSideChange}}
          as |s|
        >
          <s.Label>Side</s.Label>
          <s.Trigger>
            <s.Value />
            {{icon ChevronDown}}
          </s.Trigger>
          <s.Content>
            {{#each this.sides key="value" as |option|}}
              <s.Item @value={{option.value}} as |item|>
                {{option.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
        <Select
          @items={{this.aligns}}
          @value={{this.align}}
          @onValueChange={{this.onAlignChange}}
          as |s|
        >
          <s.Label>Align</s.Label>
          <s.Trigger>
            <s.Value />
            {{icon ChevronDown}}
          </s.Trigger>
          <s.Content>
            {{#each this.aligns key="value" as |option|}}
              <s.Item @value={{option.value}} as |item|>
                {{option.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
      </div>
      <HoverCard as |h|>
        <h.Trigger href="https://example.com/people/ines">@ines</h.Trigger>
        <h.Content @side={{this.side}} @align={{this.align}} @sideOffset={{10}}>
          <h.Arrow />
          <p>Inès Moreau</p>
          <p>Product designer. Leads the checkout redesign.</p>
        </h.Content>
      </HoverCard>
    </div>
  </template>
}
