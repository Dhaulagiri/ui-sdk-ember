import Component from "@glimmer/component"
import type { navigationMenu } from "@ui-sdk/core/navigation-menu"
import ItemIcon from "../item-icon.gts"
import type { PartModifier } from "../use-part"
import type { PrimitiveHandle } from "../use-primitive"

/** An icon inside a link. Screen readers skip it, and `@mirror` flips it in right-to-left text. */
class NavigationMenuLinkIcon extends Component<{
  Element: HTMLSpanElement
  Args: {
    handle: PrimitiveHandle<typeof navigationMenu>
    mirror?: boolean
    render?: boolean
  }
  Blocks: { default: [{ part: PartModifier; state: Record<string, unknown> }] }
}> {
  <template>
    <ItemIcon
      ...attributes
      @handle={{@handle}}
      @partName="link-icon"
      @mirror={{@mirror}}
      @render={{@render}}
      as |icon|
    >{{yield icon}}</ItemIcon>
  </template>
}

export default NavigationMenuLinkIcon
