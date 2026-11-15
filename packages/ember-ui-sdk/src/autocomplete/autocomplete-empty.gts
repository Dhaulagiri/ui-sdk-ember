import Component from "@glimmer/component"
import { autocomplete } from "@ui-sdk/core/autocomplete"
import { usePart, type PartSignature } from "../use-part"

/** Shown while no item matches. Its message is announced when it appears. */
class AutocompleteEmpty extends Component<
  PartSignature<typeof autocomplete, "empty", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "empty")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <div ...attributes {{this.part.modifier}}>
        {{~#if this.part.state.empty}}{{yield this.part.yielded}}{{/if~}}
      </div>
    {{/if}}
  </template>
}

export default AutocompleteEmpty
