import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import {
  ColorPicker,
  createColorPickerController,
} from "ember-ui-sdk/color-picker"
import { colorPickerFixture } from "tests/fixtures/color-picker.ts"
import { colorPickerOptions } from "tests/fixtures/page.ts"

const { cancel, ...options } = colorPickerOptions()

export default class ColorPickerFixture extends Component {
  f = colorPickerFixture
  options = options
  controller = createColorPickerController()
  @tracked action = ""
  @tracked committed = ""
  @tracked submitted = ""

  get oklch() {
    return this.options.space === "oklch"
  }

  onValueChange = (
    value: string,
    details: { reason: string; cancel: () => void }
  ) => {
    if (cancel) {
      return details.cancel()
    }
    this.action = `${value}:${details.reason}`
  }

  onValueCommit = (value: string, details: { reason: string }) => {
    this.committed = `${value}:${details.reason}`
  }

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    this.submitted = Array.from(
      new FormData(event.currentTarget as HTMLFormElement),
      ([key, value]) => `${key}=${value}`
    ).join("&")
  }

  usePurple = () => this.controller.setValue("rebeccapurple")

  <template>
    <form class="fixture" {{on "submit" this.onSubmit}}>
      <button type="button">Before</button>
      <ColorPicker
        aria-label={{this.f.label}}
        @name={{this.f.name}}
        @defaultValue={{this.options.defaultValue}}
        @disabled={{this.options.disabled}}
        @readOnly={{this.options.readOnly}}
        @space={{this.options.space}}
        @format={{this.options.format}}
        @gamut={{this.options.gamut}}
        @controller={{this.controller}}
        @onValueChange={{this.onValueChange}}
        @onValueCommit={{this.onValueCommit}}
        as |cp|
      >
        <cp.Area as |area|>
          {{#if this.oklch}}<area.Canvas />{{/if}}
          <area.Thumb />
        </cp.Area>
        <cp.Slider @channel="hue" as |slider|>
          <slider.Thumb />
        </cp.Slider>
        <cp.Slider @channel="alpha" as |slider|>
          <slider.Thumb />
        </cp.Slider>
        <cp.Input aria-label={{this.f.inputLabel}} />
        <cp.ChannelInput @channel="alpha" />
        <cp.Swatch />
        <cp.EyeDropper>Pick from screen</cp.EyeDropper>
        <cp.Swatches aria-label="Presets">
          {{#each this.f.swatches as |swatch|}}
            <cp.SwatchItem @value={{swatch}} />
          {{/each}}
        </cp.Swatches>
      </ColorPicker>
      <button type="button">After</button>
      <button type="submit">Save</button>
      <button type="reset">Reset</button>
      <button type="button" {{on "click" this.usePurple}}>Use purple</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
      <output aria-label="Committed">{{this.committed}}</output>
      <output aria-label="Submitted">{{this.submitted}}</output>
    </form>
  </template>
}
