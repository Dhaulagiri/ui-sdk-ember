import Component from "@glimmer/component"
import { passwordInput } from "@ui-sdk/core/password-input"
import { useFieldControl, type FieldContext } from "../field/context"
import { usePart, type PartSignature } from "../use-part"

/** The native <input>. Its type follows whether the password is shown, and form attributes come from `PasswordInput`. */
class PasswordInputControl extends Component<
  PartSignature<
    typeof passwordInput,
    "control",
    HTMLInputElement,
    { field?: FieldContext; value?: string; defaultValue?: string }
  >
> {
  part = usePart(
    this,
    () => this.args.handle,
    "control",
    () => ({
      id: this.args.id,
    })
  )
  fieldControl = useFieldControl(this, () => ({ id: this.args.id }))

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <input
        value={{@value}}
        ...attributes
        {{this.part.modifier}}
        {{this.fieldControl.modifier}}
      />
    {{/if}}
  </template>
}

export default PasswordInputControl
