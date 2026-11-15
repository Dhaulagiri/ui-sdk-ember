import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { alertDialog } from "@ui-sdk/core/alert-dialog"
import type { dialog } from "@ui-sdk/core/dialog"
import { registerController } from "../controller-target"
import { syncOptions, usePrimitive } from "../use-primitive"
import DialogBackdrop from "../dialog/dialog-backdrop.gts"
import DialogClose from "../dialog/dialog-close.gts"
import DialogContent from "../dialog/dialog-content.gts"
import DialogDescription from "../dialog/dialog-description.gts"
import DialogShortcut from "../dialog/dialog-shortcut.gts"
import DialogTitle from "../dialog/dialog-title.gts"
import DialogTrigger from "../dialog/dialog-trigger.gts"

/** A modal dialog that interrupts the user with something important and waits for an answer. Yields its parts. */
class AlertDialog extends Component<{
  Args: Record<string, unknown> & {
    /** Opens, closes and inspects the alert dialog from anywhere, and connects triggers outside it. */
    controller?: object
    /** Renders the popup into this element instead of in place. */
    container?: Element | DocumentFragment | null
  }
  Blocks: { default: [Record<string, any>] }
}> {
  // The alert dialog's slots and state are the dialog's, so the parts are shared.
  handle = usePrimitive(this, alertDialog as unknown as typeof dialog)

  constructor(owner: Owner, args: AlertDialog["args"]) {
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
          DialogContent handle=this.handle rootContainer=@container sheet=false
        )
        Title=(component DialogTitle handle=this.handle)
        Description=(component DialogDescription handle=this.handle)
        Close=(component DialogClose handle=this.handle)
        Shortcut=(component DialogShortcut handle=this.handle)
      )
    }}
  </template>
}

export default AlertDialog
