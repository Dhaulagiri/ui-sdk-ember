import { hash } from "@ember/helper"
import Component from "@glimmer/component"
import { colorPicker } from "@ui-sdk/core/color-picker"
import { usePart, type PartSignature } from "../use-part"
import ColorPickerSliderThumb from "./color-picker-slider-thumb.gts"

let count = 0

/** A track for one `channel`, drawn by `--color-slider-background`. Yields its `Thumb`. */
class ColorPickerSlider extends Component<
  PartSignature<typeof colorPicker, "slider", HTMLDivElement>
> {
  own = `ui-sdk-e-slider${++count}`
  part = usePart(
    this,
    () => this.args.handle,
    "slider",
    () => ({
      id: this.args.id ?? this.own,
    })
  )

  get id() {
    return this.args.id ?? this.own
  }

  <template>
    {{#let
      (hash
        part=this.part.modifier
        state=this.part.state
        Thumb=(component
          ColorPickerSliderThumb
          handle=@handle
          id=this.id
          channel=@channel
          orientation=@orientation
        )
      )
      as |slider|
    }}
      {{#if @render}}
        {{yield slider}}
      {{else}}
        <div ...attributes {{this.part.modifier}}>{{yield slider}}</div>
      {{/if}}
    {{/let}}
  </template>
}

export default ColorPickerSlider
