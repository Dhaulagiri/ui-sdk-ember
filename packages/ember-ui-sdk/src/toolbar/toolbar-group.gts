import Component from "@glimmer/component"
import { toolbar } from "@ui-sdk/core/toolbar"
import ToggleGroup from "../toggle/toggle-group.gts"
import Toggle from "../toggle/toggle.gts"
import { usePart, type PartSignature } from "../use-part"
import ToolbarButton from "./toolbar-button.gts"
import ToolbarInput from "./toolbar-input.gts"
import ToolbarLink from "./toolbar-link.gts"

/** A group of related items in the toolbar. `@disabled` disables every item in it. Yields the toolbar's items. */
class ToolbarGroup extends Component<
  PartSignature<typeof toolbar, "group", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "group")

  get disabled() {
    return this.part.state.disabled
  }

  <template>
    {{#let
      (hash
        part=this.part.modifier
        state=this.part.state
        Button=(component
          ToolbarButton handle=@handle groupDisabled=this.disabled
        )
        Link=(component ToolbarLink handle=@handle groupDisabled=this.disabled)
        Input=(component
          ToolbarInput handle=@handle groupDisabled=this.disabled
        )
        Toggle=(component Toggle toolbar=@handle groupDisabled=this.disabled)
        ToggleGroup=(component
          ToggleGroup toolbar=@handle groupDisabled=this.disabled
        )
      )
      as |g|
    }}
      {{#if @render}}
        {{yield g}}
      {{else}}
        <div ...attributes {{this.part.modifier}}>{{yield g}}</div>
      {{/if}}
    {{/let}}
  </template>
}

export default ToolbarGroup
