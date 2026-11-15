import Component from "@glimmer/component"
import { autocomplete } from "@ui-sdk/core/autocomplete"
import { usePart, type PartSignature } from "../use-part"
import AutocompleteItems from "./autocomplete-items.gts"

/** The listbox. Without a block, it renders the autocomplete's `items`, filtered. */
class AutocompleteList extends Component<
  PartSignature<typeof autocomplete, "list", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "list")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <div ...attributes {{this.part.modifier}}>
        {{~#if (has-block)}}{{yield this.part.yielded}}{{else if
          @handle.state.items
        }}<AutocompleteItems
            @handle={{@handle}}
            @items={{this.part.state.items}}
          />{{/if~}}
      </div>
    {{/if}}
  </template>
}

export default AutocompleteList
