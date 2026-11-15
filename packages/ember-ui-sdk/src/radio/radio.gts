import Component from "@glimmer/component"
import { radioGroup } from "@ui-sdk/core/radio"
import { useFieldControl, type FieldContext } from "../field/context"
import { usePart, type PartSignature } from "../use-part"
import RadioIndicator from "./radio-indicator.gts"

/** A radio and the hidden native radio that takes part in the form. */
class Radio extends Component<
  PartSignature<
    typeof radioGroup,
    "root",
    HTMLButtonElement,
    {
      id?: string
      field?: FieldContext
    }
  >
> {
  fieldControl = useFieldControl(this, () => ({ id: this.args.id }))
  item = () => ({
    value: this.args.value,
    disabled: this.args.disabled || this.fieldControl.disabled,
  })
  root = usePart(this, () => this.args.handle, "root", this.item)
  input = usePart(this, () => this.args.handle, "input", this.item)

  <template>
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        Indicator=(component RadioIndicator handle=@handle value=@value)
      )
      as |r|
    }}
      {{#if @render}}
        {{yield r}}
      {{else}}
        <button
          id={{@id}}
          ...attributes
          {{this.root.modifier}}
          {{this.fieldControl.modifier}}
        >{{yield r}}</button>
      {{/if}}
    {{/let}}
    <input {{this.input.modifier}} />
  </template>
}

export default Radio
