import Component from "@glimmer/component"
import { colorPicker } from "@ui-sdk/core/color-picker"
import { usePart, type PartSignature } from "../use-part"

/** The area's thumb: a slider screen readers hear as both channels. */
class ColorPickerAreaThumb extends Component<
  PartSignature<typeof colorPicker, "area-thumb", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "area-thumb")

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

export default ColorPickerAreaThumb
