import { hash } from "@ember/helper"
import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { menu, type MenuData } from "@ui-sdk/core/menu"
import { registerController } from "../controller-target"
import {
  syncOptions,
  usePrimitive,
  type PrimitiveHandle,
} from "../use-primitive"
import MenuCheckboxItem from "./menu-checkbox-item.gts"
import MenuContent from "./menu-content.gts"
import MenuContextTrigger from "./menu-context-trigger.gts"
import MenuGroup from "./menu-group.gts"
import MenuItem from "./menu-item.gts"
import MenuItemIcon from "./menu-item-icon.gts"
import MenuItems from "./menu-items.gts"
import MenuRadioGroup from "./menu-radio-group.gts"
import MenuSeparator from "./menu-separator.gts"
import MenuShortcut from "./menu-shortcut.gts"
import MenuSub from "./menu-sub.gts"
import MenuTrigger from "./menu-trigger.gts"

/** A list of actions and options, opened from a button or a right-click. Yields its parts. */
class Menu extends Component<{
  Args: Record<string, unknown> & {
    /** The menu as data. Renders the content for you, unless you place a `Content` of your own. */
    items?: MenuData
    /** Opens, closes and inspects the menu from anywhere, and connects triggers outside it. */
    controller?: object
    /** Renders the popup into this element instead of in place. */
    container?: Element | DocumentFragment | null
    /** The menubar the menu joins. A menubar's yielded `Menu` passes it. */
    menubar?: PrimitiveHandle
  }
  Blocks: { default: [Record<string, any>] }
}> {
  @tracked owners = 0
  menubarApi = () => this.args.menubar?.api
  handle = usePrimitive(this, menu, () => ({
    menubar: (this.args.menubar ? this.menubarApi : undefined) as never,
  }))

  constructor(owner: Owner, args: Menu["args"]) {
    super(owner, args)
    registerController(this, () => this.args.controller, this.handle)
  }

  // A data menu renders its content, unless the app renders one in the block.
  // Counted after the render that made the content, which may have read it.
  claim = () => {
    queueMicrotask(() => this.owners++)
    return () => queueMicrotask(() => this.owners--)
  }

  get ownContent() {
    return this.args.items && !this.owners
  }

  <template>
    {{syncOptions this.handle}}
    {{yield
      (hash
        handle=this.handle
        Trigger=(component MenuTrigger handle=this.handle)
        ContextTrigger=(component MenuContextTrigger handle=this.handle)
        Content=(component
          MenuContent
          handle=this.handle
          rootContainer=@container
          claim=(if @items this.claim)
        )
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
    {{#if this.ownContent}}
      <MenuContent @handle={{this.handle}} @rootContainer={{@container}}>
        {{! @glint-expect-error ownContent holds only while items is set }}
        <MenuItems @handle={{this.handle}} @items={{@items}} />
      </MenuContent>
    {{/if}}
  </template>
}

export default Menu
