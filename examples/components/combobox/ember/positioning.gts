import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { Check, ChevronDown } from "lucide"
import { Checkbox } from "ember-ui-sdk/checkbox"
import { Combobox } from "ember-ui-sdk/combobox"
import { Select } from "ember-ui-sdk/select"
import { icon } from "../../../shared/ember/icon"

const frameworks = [
  { value: "next", label: "Next.js" },
  { value: "sveltekit", label: "SvelteKit" },
  { value: "nuxt", label: "Nuxt" },
  { value: "remix", label: "Remix" },
  { value: "astro", label: "Astro" },
  { value: "solidstart", label: "SolidStart" },
  { value: "qwik", label: "Qwik City" },
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
  @tracked side = "bottom"
  @tracked align = "start"
  @tracked anchored = false

  sides = sides
  aligns = aligns
  frameworks = frameworks

  get anchor() {
    return this.anchored ? "#positioning-box" : null
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
      <div id="positioning-box" data-slot="card">
        <Combobox as |c|>
          <c.Input aria-label="Framework" placeholder="Framework" />
          <c.Content
            @side={{this.side}}
            @align={{this.align}}
            @sideOffset={{10}}
            @alignOffset={{0}}
            @collisionPadding={{16}}
            @anchor={{this.anchor}}
          >
            <c.Empty>No frameworks found.</c.Empty>
            <c.List>
              {{#each this.frameworks key="value" as |framework|}}
                <c.Item
                  @value={{framework.value}}
                  @label={{framework.label}}
                  as |item|
                >
                  {{framework.label}}
                  <item.Indicator>{{icon Check}}</item.Indicator>
                </c.Item>
              {{/each}}
            </c.List>
          </c.Content>
        </Combobox>
      </div>
    </div>
  </template>
}
