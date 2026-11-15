import Component from "@glimmer/component"
import { selectItemIcons } from "@ui-sdk/core/renderer"
import type { select } from "@ui-sdk/core/select"
import ItemIcon from "../item-icon.gts"
import type { PartModifier } from "../use-part"
import type { PrimitiveHandle } from "../use-primitive"

/**
 * An icon inside an item. `SelectValueIcon` shows the selected item's in the
 * trigger. Screen readers, typeahead and filtering skip it, and `@mirror`
 * flips it in right-to-left text.
 */
class SelectItemIcon extends Component<{
  Element: HTMLSpanElement
  Args: {
    handle: PrimitiveHandle<typeof select>
    item?: string
    mirror?: boolean
    render?: boolean
  }
  Blocks: { default: [{ part: PartModifier; state: Record<string, unknown> }] }
}> {
  feature = this.args.handle.instance.use(selectItemIcons)

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

export default SelectItemIcon
