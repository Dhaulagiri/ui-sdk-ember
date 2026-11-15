import Component from "@glimmer/component"
import { select } from "@ui-sdk/core/select"
import { usePart, type PartSignature } from "../use-part"
import SelectItems from "./select-items.gts"

/** The listbox inside the content, for content that holds more than the items, like a search field. Without a block, it renders the select's `items`. */
class SelectList extends Component<
  PartSignature<typeof select, "list", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "list")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <div ...attributes {{this.part.modifier}}>
        {{~#if (has-block)}}{{yield this.part.yielded}}{{else if
          @handle.state.items
        }}<SelectItems
            @handle={{@handle}}
            @items={{this.part.state.items}}
          />{{/if~}}
      </div>
    {{/if}}
  </template>
}

export default SelectList
