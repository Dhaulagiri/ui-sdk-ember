import { hash } from "@ember/helper"
import Component from "@glimmer/component"
import { menu } from "@ui-sdk/core/menu"
import {
  syncOptions,
  usePrimitive,
  type PrimitiveHandle,
} from "../use-primitive"
import MenuCheckboxItem from "./menu-checkbox-item.gts"
import MenuContent from "./menu-content.gts"
import MenuGroup from "./menu-group.gts"
import MenuItem from "./menu-item.gts"
import MenuItemIcon from "./menu-item-icon.gts"
import MenuItems from "./menu-items.gts"
import MenuRadioGroup from "./menu-radio-group.gts"
import MenuSeparator from "./menu-separator.gts"
import MenuShortcut from "./menu-shortcut.gts"
import MenuSubTrigger from "./menu-sub-trigger.gts"

/** A submenu. Yields its `Trigger`, `Content` and the parts inside it. */
class MenuSub extends Component<{
  Args: Record<string, unknown> & {
    /** The menu the submenu opens from. Its yielded `Sub` passes it. */
    parent: PrimitiveHandle<typeof menu>
  }
  Blocks: { default: [Record<string, any>] }
}> {
  handle = usePrimitive(this, menu, () => ({ parent: this.args.parent.api }))

  <template>
    {{syncOptions this.handle}}
    {{yield
      (hash
        handle=this.handle
        Trigger=(component MenuSubTrigger handle=this.handle)
        Content=(component MenuContent handle=this.handle)
        Item=(component MenuItem handle=this.handle)
        CheckboxItem=(component MenuCheckboxItem handle=this.handle)
        RadioGroup=(component MenuRadioGroup handle=this.handle)
        Group=(component MenuGroup handle=this.handle)
        Separator=(component MenuSeparator handle=this.handle)
        Shortcut=(component MenuShortcut handle=this.handle)
        ItemIcon=(component MenuItemIcon handle=this.handle)
        Sub=(component MenuSub parent=this.handle)
        Items=(component MenuItems handle=this.handle)
      )
    }}
  </template>
}

export default MenuSub
