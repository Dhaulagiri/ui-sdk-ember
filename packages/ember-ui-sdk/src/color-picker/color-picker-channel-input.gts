import Component from "@glimmer/component"
import { colorPicker } from "@ui-sdk/core/color-picker"
import { usePart, type PartSignature } from "../use-part"

/** A number input for one `channel`, in the units people read it in. */
class ColorPickerChannelInput extends Component<
  PartSignature<typeof colorPicker, "channel-input", HTMLInputElement>
> {
  part = usePart(this, () => this.args.handle, "channel-input")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <input ...attributes {{this.part.modifier}} />
    {{/if}}
  </template>
}

export default ColorPickerChannelInput
