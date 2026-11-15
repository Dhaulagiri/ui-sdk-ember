import Component from "@glimmer/component"
import { colorPicker } from "@ui-sdk/core/color-picker"
import { usePart, type PartSignature } from "../use-part"

/** The slider's thumb, at `--color-slider-thumb-position`. */
class ColorPickerSliderThumb extends Component<
  PartSignature<typeof colorPicker, "slider-thumb", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "slider-thumb")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <div ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</div>
    {{/if}}
  </template>
}

export default ColorPickerSliderThumb
