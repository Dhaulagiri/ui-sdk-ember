import Component from "@glimmer/component"
import { autocomplete } from "@ui-sdk/core/autocomplete"
import { usePart, type PartSignature } from "../use-part"

/** An arrow on the popup's edge that points at the field. */
class AutocompleteArrow extends Component<
  PartSignature<typeof autocomplete, "arrow", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "arrow")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <div ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</div>
    {{/if}}
  </template>
}

export default AutocompleteArrow
