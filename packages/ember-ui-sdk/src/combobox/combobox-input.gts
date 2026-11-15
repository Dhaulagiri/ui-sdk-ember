import Component from "@glimmer/component"
import { combobox } from "@ui-sdk/core/combobox"
import { useFieldControl, type FieldContext } from "../field/context"
import { relocate } from "../relocate"
import { usePart, type PartSignature } from "../use-part"
import type { Shared } from "./combobox.gts"

/** The text input that filters the list and holds the chosen item's label. While the list presents as a sheet, it moves into the sheet's header. */
class ComboboxInput extends Component<
  PartSignature<
    typeof combobox,
    "input",
    HTMLInputElement,
    { shared: Shared; id?: string; field?: FieldContext }
  >
> {
  fieldControl = useFieldControl(this, () => ({ id: this.args.id }))
  part = usePart(this, () => this.args.handle, "input")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <input
        ...attributes
        {{this.part.modifier}}
        {{this.fieldControl.modifier}}
        {{relocate @shared.header}}
      />
    {{/if}}
  </template>
}

export default ComboboxInput
