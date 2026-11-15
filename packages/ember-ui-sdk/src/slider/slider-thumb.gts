import Component from "@glimmer/component"
import { slider } from "@ui-sdk/core/slider"
import type { FieldContext } from "../field/context"
import { usePart, type PartSignature } from "../use-part"
import SliderThumbInput from "./slider-thumb-input.gts"

/**
 * A thumb, with the native range input that takes focus inside it.
 * `@ariaLabel`, `@ariaLabelledby` and `@ariaDescribedby` go to that input.
 * With `@render`, render the yielded `Input` inside your element.
 */
class SliderThumb extends Component<
  PartSignature<
    typeof slider,
    "thumb",
    HTMLDivElement,
    {
      ariaLabel?: string
      ariaLabelledby?: string
      ariaDescribedby?: string
      field?: FieldContext
    }
  >
> {
  part = usePart(
    this,
    () => this.args.handle,
    "thumb",
    () => ({
      index: this.args.index ?? 0,
      id: String(this.args.index ?? 0),
    })
  )

  <template>
    {{#let
      (hash
        part=this.part.modifier
        state=this.part.state
        Input=(component
          SliderThumbInput
          handle=@handle
          index=@index
          ariaLabel=@ariaLabel
          ariaLabelledby=@ariaLabelledby
          ariaDescribedby=@ariaDescribedby
          field=@field
        )
      )
      as |thumb|
    }}
      {{#if @render}}
        {{yield thumb}}
      {{else}}
        <div ...attributes {{this.part.modifier}}>
          {{~yield thumb~}}
          <thumb.Input />
        </div>
      {{/if}}
    {{/let}}
  </template>
}

export default SliderThumb
