import Component from "@glimmer/component"
import { selectItemIcons } from "@ui-sdk/core/renderer"
import type { select } from "@ui-sdk/core/select"
import type { PrimitiveHandle } from "../use-primitive"
import ValueIcon from "../value-icon.gts"

/**
 * The selected item's icon, copied from its `SelectItemIcon`, like before
 * the value in the trigger. Rendered while one item is selected and it has an icon.
 */
class SelectValueIcon extends Component<{
  Element: HTMLSpanElement
  Args: { handle: PrimitiveHandle<typeof select> }
}> {
  feature = this.args.handle.instance.use(selectItemIcons)

  <template><ValueIcon ...attributes @handle={{@handle}} /></template>
}

export default SelectValueIcon
