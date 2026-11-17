import { hash } from "@ember/helper"
import Component from "@glimmer/component"
import { navigationMenu } from "@ui-sdk/core/navigation-menu"
import { usePart, type PartSignature } from "../use-part"
import NavigationMenuItem from "./navigation-menu-item.gts"

/** The list of top-level items. */
class NavigationMenuList extends Component<
  PartSignature<
    typeof navigationMenu,
    "list",
    HTMLUListElement,
    { rootContainer?: Element | DocumentFragment | null }
  >
> {
  part = usePart(this, () => this.args.handle, "list")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <ul ...attributes {{this.part.modifier}}>{{yield
          (hash
            part=this.part.modifier
            state=this.part.state
            Item=(component
              NavigationMenuItem handle=@handle rootContainer=@rootContainer
            )
          )
        }}</ul>
    {{/if}}
  </template>
}

export default NavigationMenuList
