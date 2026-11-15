import Component from "@glimmer/component"
import { colorPicker } from "@ui-sdk/core/color-picker"
import { usePart, type PartSignature } from "../use-part"

/** A preset color, as `--color-picker-color`. Pressing it sets the value. */
class ColorPickerSwatchItem extends Component<
  PartSignature<typeof colorPicker, "swatch-item", HTMLButtonElement>
> {
  part = usePart(this, () => this.args.handle, "swatch-item")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <button ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</button>
    {{/if}}
  </template>
}

export default ColorPickerSwatchItem
