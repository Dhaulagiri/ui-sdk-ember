import Component from "@glimmer/component"
import { autocomplete } from "@ui-sdk/core/autocomplete"
import { usePart, type PartSignature } from "../use-part"

/** A visible label for the field. */
class AutocompleteLabel extends Component<
  PartSignature<typeof autocomplete, "label", HTMLLabelElement>
> {
  part = usePart(this, () => this.args.handle, "label")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <label ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</label>
    {{/if}}
  </template>
}

export default AutocompleteLabel
