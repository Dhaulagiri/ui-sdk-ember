import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { Pipette } from "lucide"
import { formatColor, parseColor, type ColorFormat } from "@ui-sdk/core/color"
import { ColorPicker } from "ember-ui-sdk/color-picker"
import { icon } from "../../../shared/ember/icon"

const formats: { label: string; value: ColorFormat }[] = [
  { label: "Hex", value: "hex" },
  { label: "RGB", value: "srgb" },
  { label: "HSL", value: "hsl" },
  { label: "OKLCH", value: "oklch" },
]

const presets = [
  "#ef4444",
  "#f97316",
  "#eab308",
  "#22c55e",
  "#0ea5e9",
  "#6366f1",
  "#a855f7",
  "#ec4899",
]

export default class Basic extends Component {
  formats = formats
  presets = presets
  @tracked format: ColorFormat = "hex"
  @tracked value = "#0ea5e9"

  onValueChange = (next: string) => {
    this.value = next
  }

  changeFormat = (event: Event) => {
    const next = (event.currentTarget as HTMLSelectElement).value as ColorFormat
    this.format = next
    this.value = formatColor(parseColor(this.value)!, next)
  }

  <template>
    <ColorPicker
      @value={{this.value}}
      @onValueChange={{this.onValueChange}}
      @format={{this.format}}
      aria-label="Brand color"
      as |c|
    >
      <c.Area as |a|>
        <a.Thumb />
      </c.Area>
      <div data-slot="row">
        <c.EyeDropper aria-label="Pick from screen">{{icon
            Pipette
          }}</c.EyeDropper>
        <div data-slot="color-picker-sliders">
          <c.Slider @channel="hue" as |s|>
            <s.Thumb />
          </c.Slider>
          <c.Slider @channel="alpha" as |s|>
            <s.Thumb />
          </c.Slider>
        </div>
        <c.Swatch />
      </div>
      <div data-slot="row">
        <select
          aria-label="Format"
          value={{this.format}}
          {{on "change" this.changeFormat}}
        >
          {{#each this.formats key="value" as |choice|}}
            <option value={{choice.value}}>{{choice.label}}</option>
          {{/each}}
        </select>
        <c.Input aria-label="Color" />
      </div>
      <c.Swatches aria-label="Presets">
        {{#each this.presets key="@identity" as |preset|}}
          <c.SwatchItem @value={{preset}} />
        {{/each}}
      </c.Swatches>
    </ColorPicker>
  </template>
}
