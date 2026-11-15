import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { drawer } from "@ui-sdk/core/drawer"
import { registerController } from "../controller-target"
import { syncOptions, usePrimitive } from "../use-primitive"
import DrawerBackdrop from "./drawer-backdrop.gts"
import DrawerClose from "./drawer-close.gts"
import DrawerContent from "./drawer-content.gts"
import DrawerDescription from "./drawer-description.gts"
import DrawerHandle from "./drawer-handle.gts"
import DrawerOutlet from "./drawer-outlet.gts"
import DrawerShortcut from "./drawer-shortcut.gts"
import DrawerTitle from "./drawer-title.gts"
import DrawerTrigger from "./drawer-trigger.gts"

/** A dialog presented as a sheet that slides in from an edge. Yields its parts. */
class Drawer extends Component<{
  Args: Record<string, unknown> & {
    /** Opens, closes and inspects the drawer from anywhere, and connects triggers and outlets outside it. */
    controller?: object
    /** Renders the drawer into this element instead of in place. */
    container?: Element | DocumentFragment | null
  }
  Blocks: { default: [Record<string, any>] }
}> {
  handle = usePrimitive(this, drawer)

  constructor(owner: Owner, args: Drawer["args"]) {
    super(owner, args)
    registerController(this, () => this.args.controller, this.handle)
  }

  <template>
    {{syncOptions this.handle}}
    {{yield
      (hash
        handle=this.handle
        Trigger=(component DrawerTrigger handle=this.handle)
        Backdrop=(component
          DrawerBackdrop handle=this.handle rootContainer=@container
        )
        Content=(component
          DrawerContent handle=this.handle rootContainer=@container
        )
        Handle=(component DrawerHandle handle=this.handle)
        Title=(component DrawerTitle handle=this.handle)
        Description=(component DrawerDescription handle=this.handle)
        Close=(component DrawerClose handle=this.handle)
        Shortcut=(component DrawerShortcut handle=this.handle)
        Outlet=(component DrawerOutlet handle=this.handle)
      )
    }}
  </template>
}

export default Drawer
