import Component from "@glimmer/component"
import { colorPicker } from "@ui-sdk/core/color-picker"
import { usePart, type PartSignature } from "../use-part"

/** A button that picks a color from the screen, where the browser can. Elsewhere it's disabled, with `data-unsupported`. */
class ColorPickerEyeDropper extends Component<
  PartSignature<typeof colorPicker, "eye-dropper", HTMLButtonElement>
> {
  part = usePart(this, () => this.args.handle, "eye-dropper")

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

export default ColorPickerEyeDropper
