import Component from "@glimmer/component"
import { slider } from "@ui-sdk/core/slider"
import { useFieldControl, type FieldContext } from "../field/context"
import { usePart, type PartSignature } from "../use-part"

// The native range input inside a thumb, which a thumb with `@render` yields as `Input`.
class SliderThumbInput extends Component<
  PartSignature<
    typeof slider,
    "thumb-input",
    HTMLInputElement,
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
    "thumb-input",
    () => ({
      index: this.args.index ?? 0,
      id: String(this.args.index ?? 0),
    })
  )
  fieldControl = useFieldControl(this, () => ({
    id: this.part.attrs.id,
    describedBy: this.args.ariaDescribedby,
  }))

  <template>
    <input
      aria-label={{@ariaLabel}}
      aria-labelledby={{@ariaLabelledby}}
      aria-describedby={{@ariaDescribedby}}
      ...attributes
      {{this.part.modifier}}
      {{this.fieldControl.modifier}}
    />
  </template>
}

export default SliderThumbInput
