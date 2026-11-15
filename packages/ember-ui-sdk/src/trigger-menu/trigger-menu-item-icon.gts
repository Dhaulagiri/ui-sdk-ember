import Component from "@glimmer/component"
import type { triggerMenu } from "@ui-sdk/core/trigger-menu"
import ItemIcon from "../item-icon.gts"
import type { PartModifier } from "../use-part"
import type { PrimitiveHandle } from "../use-primitive"

/**
 * An icon inside an item. Screen readers, typeahead and filtering skip it, and `@mirror`
 * flips it in right-to-left text.
 */
class TriggerMenuItemIcon extends Component<{
  Element: HTMLSpanElement
  Args: {
    handle: PrimitiveHandle<typeof triggerMenu>
    item?: string
    mirror?: boolean
    render?: boolean
  }
  Blocks: { default: [{ part: PartModifier; state: Record<string, unknown> }] }
}> {
  <template>
    <ItemIcon
      ...attributes
      @handle={{@handle}}
      @partName="item-icon"
      @item={{@item}}
      @mirror={{@mirror}}
      @render={{@render}}
      as |icon|
    >{{yield icon}}</ItemIcon>
  </template>
}

export default TriggerMenuItemIcon
