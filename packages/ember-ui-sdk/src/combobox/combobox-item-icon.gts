import Component from "@glimmer/component"
import { comboboxItemIcons } from "@ui-sdk/core/renderer"
import type { combobox } from "@ui-sdk/core/combobox"
import ItemIcon from "../item-icon.gts"
import type { PartModifier } from "../use-part"
import type { PrimitiveHandle } from "../use-primitive"

/**
 * An icon inside an item. `ComboboxValueIcon` shows the selected item's
 * next to the input. Screen readers, typeahead and filtering skip it, and `@mirror`
 * flips it in right-to-left text.
 */
class ComboboxItemIcon extends Component<{
  Element: HTMLSpanElement
  Args: {
    handle: PrimitiveHandle<typeof combobox>
    item?: string
    mirror?: boolean
    render?: boolean
  }
  Blocks: { default: [{ part: PartModifier; state: Record<string, unknown> }] }
}> {
  feature = this.args.handle.instance.use(comboboxItemIcons)

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

export default ComboboxItemIcon
