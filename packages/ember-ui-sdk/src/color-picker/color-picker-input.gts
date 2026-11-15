import Component from "@glimmer/component"
import { colorPicker } from "@ui-sdk/core/color-picker"
import { usePart, type PartSignature } from "../use-part"

/** A text input that reads any CSS color on Enter or blur. Text that isn't one goes back to the value. The core writes its text. */
class ColorPickerInput extends Component<
  PartSignature<typeof colorPicker, "input", HTMLInputElement>
> {
  part = usePart(this, () => this.args.handle, "input")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <input ...attributes {{this.part.modifier}} />
    {{/if}}
  </template>
}

export default ColorPickerInput
