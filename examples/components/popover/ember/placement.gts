import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check, ChevronDown } from "lucide"
import { Popover } from "ember-ui-sdk/popover"
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

type Side = "top" | "right" | "bottom" | "left"
type Align = "start" | "center" | "end"

export default class Placement extends Component {
  @tracked side: Side = "bottom"
  @tracked align: Align = "center"

  onSideChange = (next: string | null) => {
    if (next) {
      this.side = next as Side
    }
  }

  onAlignChange = (next: string | null) => {
    if (next) {
      this.align = next as Align
    }
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <Select
          @items={{sides}}
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
            {{#each sides key="value" as |option|}}
              <s.Item @value={{option.value}} as |item|>
                {{option.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
        <Select
          @items={{aligns}}
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
            {{#each aligns key="value" as |option|}}
              <s.Item @value={{option.value}} as |item|>
                {{option.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
      </div>
      <Popover as |p|>
        <p.Trigger>Delivery</p.Trigger>
        <p.Content @side={{this.side}} @align={{this.align}} @sideOffset={{8}}>
          <p.Title>Delivery window</p.Title>
          <p.Description>Arrives Tuesday between 9 AM and noon.</p.Description>
        </p.Content>
      </Popover>
    </div>
  </template>
}
