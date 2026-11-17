import { hash } from "@ember/helper"
import Component from "@glimmer/component"
import { colorPicker } from "@ui-sdk/core/color-picker"
import { usePart, type PartSignature } from "../use-part"
import ColorPickerAreaCanvas from "./color-picker-area-canvas.gts"
import ColorPickerAreaThumb from "./color-picker-area-thumb.gts"

/** A surface for two channels, `x` and `y`. Its background comes from `--color-area-background` where gradients draw it, or a `Canvas`. Yields its `Canvas` and `Thumb`. */
class ColorPickerArea extends Component<
  PartSignature<typeof colorPicker, "area", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "area")

  <template>
    {{#let
      (hash
        part=this.part.modifier
        state=this.part.state
        Canvas=(component ColorPickerAreaCanvas handle=@handle x=@x y=@y)
        Thumb=(component ColorPickerAreaThumb handle=@handle x=@x y=@y)
      )
      as |area|
    }}
      {{#if @render}}
        {{yield area}}
      {{else}}
        <div ...attributes {{this.part.modifier}}>{{yield area}}</div>
      {{/if}}
    {{/let}}
  </template>
}

export default ColorPickerArea
