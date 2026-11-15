import Component from "@glimmer/component"
import { autocomplete } from "@ui-sdk/core/autocomplete"
import { usePart, type PartSignature } from "../use-part"

/** A polite live region for loading and result counts. Its content is yours, from its children's state. */
class AutocompleteStatus extends Component<
  PartSignature<typeof autocomplete, "status", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "status")

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

export default AutocompleteStatus
