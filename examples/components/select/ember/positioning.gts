import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check, ChevronDown } from "lucide"
import { Checkbox } from "ember-ui-sdk/checkbox"
import { Select } from "ember-ui-sdk/select"
import { icon } from "../../../shared/ember/icon"

const fonts = [
  { value: "inter", label: "Inter" },
  { value: "geist", label: "Geist" },
  { value: "source-serif", label: "Source Serif" },
  { value: "geist-mono", label: "Geist Mono" },
]

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

export default class Positioning extends Component {
  fonts = fonts
  sides = sides
  aligns = aligns
  @tracked side = "bottom"
  @tracked align = "start"
  @tracked anchored = false

  get anchor() {
    return this.anchored ? "#select-box" : null
  }

  onSideChange = (next: string | null) => {
    if (next) this.side = next
  }

  onAlignChange = (next: string | null) => {
    if (next) this.align = next
  }

  onCheckedChange = (next: boolean | "indeterminate") => {
    this.anchored = next === true
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
        <label data-slot="label">
          <Checkbox
            @checked={{this.anchored}}
            @onCheckedChange={{this.onCheckedChange}}
            as |c|
          >
            <c.Indicator>{{icon Check}}</c.Indicator>
          </Checkbox>
          Anchor to the box
        </label>
      </div>
      <div id="select-box" data-slot="card">
        <Select @defaultValue="inter" as |s|>
          <s.Trigger aria-label="Font">
            <s.Value />
            {{icon ChevronDown}}
          </s.Trigger>
          <s.Content
            @side={{this.side}}
            @align={{this.align}}
            @sideOffset={{10}}
            @alignOffset={{0}}
            @collisionPadding={{16}}
            @anchor={{this.anchor}}
          >
            <s.Arrow />
            {{#each this.fonts key="value" as |font|}}
              <s.Item @value={{font.value}} as |item|>
                {{font.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
      </div>
    </div>
  </template>
}
