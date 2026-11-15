import Component from "@glimmer/component"
import { autocomplete } from "@ui-sdk/core/autocomplete"
import { useFieldControl, type FieldContext } from "../field/context"
import { relocate } from "../relocate"
import { usePart, type PartSignature } from "../use-part"
import type { Shared } from "./autocomplete.gts"

/** The text input that filters the list and holds the chosen item's label. While the list presents as a sheet, it moves into the sheet's header. */
class AutocompleteInput extends Component<
  PartSignature<
    typeof autocomplete,
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

export default AutocompleteInput
