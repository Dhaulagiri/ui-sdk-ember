import Component from "@glimmer/component"
import { colorPicker } from "@ui-sdk/core/color-picker"
import { usePart, type PartSignature } from "../use-part"

/** The color itself, as `--color-picker-color`, named for screen readers. */
class ColorPickerSwatch extends Component<
  PartSignature<typeof colorPicker, "swatch", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "swatch")

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

export default ColorPickerSwatch
