import Component from "@glimmer/component"
import { numberInput } from "@ui-sdk/core/number-input"
import { useFieldControl, type FieldContext } from "../field/context"
import { usePart, type PartSignature } from "../use-part"

/** The text field, which shows the formatted number and takes typing. */
class NumberInputControl extends Component<
  PartSignature<
    typeof numberInput,
    "control",
    HTMLInputElement,
    { field?: FieldContext; id?: string }
  >
> {
  part = usePart(this, () => this.args.handle, "control")
  fieldControl = useFieldControl(this, () => ({ id: this.args.id }))

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <input
        id={{@id}}
        ...attributes
        {{this.part.modifier}}
        {{this.fieldControl.modifier}}
      />
    {{/if}}
  </template>
}

export default NumberInputControl
