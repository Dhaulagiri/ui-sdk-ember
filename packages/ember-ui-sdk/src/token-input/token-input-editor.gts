import Component from "@glimmer/component"
import { tokenInput } from "@ui-sdk/core/token-input"
import { useFieldControl, type FieldContext } from "../field/context"
import { usePart, type PartSignature } from "../use-part"

/** The editable text. The core owns its content, so it takes no block; style it, and show the placeholder with `data-empty`. */
class TokenInputEditor extends Component<
  PartSignature<
    typeof tokenInput,
    "editor",
    HTMLDivElement,
    { id?: string; field?: FieldContext }
  >
> {
  fieldControl = useFieldControl(this, () => ({ id: this.args.id }))
  part = usePart(this, () => this.args.handle, "editor")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <div
        ...attributes
        {{this.part.modifier}}
        {{this.fieldControl.modifier}}
      ></div>
    {{/if}}
  </template>
}

export default TokenInputEditor
