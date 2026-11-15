import Component from "@glimmer/component"
import { triggerMenu } from "@ui-sdk/core/trigger-menu"
import { usePart, type PartSignature } from "../use-part"
import TriggerMenuItems from "./trigger-menu-items.gts"

/** The listbox. Without a block, it renders the current trigger's items. */
class TriggerMenuList extends Component<
  PartSignature<typeof triggerMenu, "list", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "list")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <div ...attributes {{this.part.modifier}}>
        {{~#if (has-block)}}{{yield this.part.yielded}}{{else}}<TriggerMenuItems
            @handle={{@handle}}
            @items={{this.part.state.items}}
          />{{/if~}}
      </div>
    {{/if}}
  </template>
}

export default TriggerMenuList
