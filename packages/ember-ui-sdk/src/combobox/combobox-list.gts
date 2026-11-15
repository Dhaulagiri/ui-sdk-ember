import Component from "@glimmer/component"
import { combobox } from "@ui-sdk/core/combobox"
import { usePart, type PartSignature } from "../use-part"
import ComboboxItems from "./combobox-items.gts"

/** The listbox. Without a block, it renders the combobox's `items`, filtered. */
class ComboboxList extends Component<
  PartSignature<typeof combobox, "list", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "list")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <div ...attributes {{this.part.modifier}}>
        {{~#if (has-block)}}{{yield this.part.yielded}}{{else if
          @handle.state.items
        }}<ComboboxItems
            @handle={{@handle}}
            @items={{this.part.state.items}}
          />{{/if~}}
      </div>
    {{/if}}
  </template>
}

export default ComboboxList
