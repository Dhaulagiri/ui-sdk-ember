import Component from "@glimmer/component"
import { colorPicker } from "@ui-sdk/core/color-picker"
import { usePart, type PartSignature } from "../use-part"

/** Paints the area pixel by pixel, for channels no gradient draws, like OKLCH's chroma by lightness. Colors outside the gamut stay transparent. */
class ColorPickerAreaCanvas extends Component<
  PartSignature<typeof colorPicker, "area-canvas", HTMLElement>
> {
  part = usePart(this, () => this.args.handle, "area-canvas")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <canvas ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</canvas>
    {{/if}}
  </template>
}

export default ColorPickerAreaCanvas
