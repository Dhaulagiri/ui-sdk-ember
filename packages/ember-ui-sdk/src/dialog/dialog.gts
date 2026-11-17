import { hash } from "@ember/helper"
import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { dialog } from "@ui-sdk/core/dialog"
import { registerController } from "../controller-target"
import { syncOptions, usePrimitive } from "../use-primitive"
import DialogBackdrop from "./dialog-backdrop.gts"
import DialogClose from "./dialog-close.gts"
import DialogContent from "./dialog-content.gts"
import DialogDescription from "./dialog-description.gts"
import DialogShortcut from "./dialog-shortcut.gts"
import DialogTitle from "./dialog-title.gts"
import DialogTrigger from "./dialog-trigger.gts"

/** A window over the page that asks for the user's attention. Yields its parts. */
class Dialog extends Component<{
  Args: Record<string, unknown> & {
    /** Opens, closes and inspects the dialog from anywhere, and connects triggers outside it. */
    controller?: object
    /** Renders the popup into this element instead of in place. */
    container?: Element | DocumentFragment | null
  }
  Blocks: { default: [Record<string, any>] }
}> {
  handle = usePrimitive(this, dialog)

  constructor(owner: Owner, args: Dialog["args"]) {
    super(owner, args)
    registerController(this, () => this.args.controller, this.handle)
  }

  <template>
    {{syncOptions this.handle}}
    {{yield
      (hash
        handle=this.handle
        Trigger=(component DialogTrigger handle=this.handle)
        Backdrop=(component
          DialogBackdrop handle=this.handle rootContainer=@container
        )
        Content=(component
          DialogContent handle=this.handle rootContainer=@container sheet=true
        )
        Title=(component DialogTitle handle=this.handle)
        Description=(component DialogDescription handle=this.handle)
        Close=(component DialogClose handle=this.handle)
        Shortcut=(component DialogShortcut handle=this.handle)
      )
    }}
  </template>
}

export default Dialog
