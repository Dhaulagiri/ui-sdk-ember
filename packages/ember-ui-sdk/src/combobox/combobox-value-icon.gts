import Component from "@glimmer/component"
import { comboboxItemIcons } from "@ui-sdk/core/renderer"
import type { combobox } from "@ui-sdk/core/combobox"
import type { PrimitiveHandle } from "../use-primitive"
import ValueIcon from "../value-icon.gts"

/**
 * The selected item's icon, copied from its `ComboboxItemIcon`, like next to
 * the input. Rendered while one item is selected and it has an icon.
 */
class ComboboxValueIcon extends Component<{
  Element: HTMLSpanElement
  Args: { handle: PrimitiveHandle<typeof combobox> }
}> {
  feature = this.args.handle.instance.use(comboboxItemIcons)

  <template><ValueIcon ...attributes @handle={{@handle}} /></template>
}

export default ComboboxValueIcon
