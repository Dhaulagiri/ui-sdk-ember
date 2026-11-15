import Component from "@glimmer/component"
import { colorPicker } from "@ui-sdk/core/color-picker"
import { usePart, type PartSignature } from "../use-part"

/** A list of preset colors. Arrow keys move between them. */
class ColorPickerSwatches extends Component<
  PartSignature<typeof colorPicker, "swatches", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "swatches")

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

export default ColorPickerSwatches
