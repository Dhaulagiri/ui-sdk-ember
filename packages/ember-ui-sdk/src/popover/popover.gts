import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import type { ChangeDetails } from "@ui-sdk/core"
import { popover } from "@ui-sdk/core/popover"
import { registerController } from "../controller-target"
import { syncOptions, usePrimitive } from "../use-primitive"
import PopoverArrow from "./popover-arrow.gts"
import PopoverClose from "./popover-close.gts"
import PopoverContent from "./popover-content.gts"
import PopoverDescription from "./popover-description.gts"
import PopoverShortcut from "./popover-shortcut.gts"
import PopoverTitle from "./popover-title.gts"
import PopoverTrigger from "./popover-trigger.gts"

/** Rich content in a floating panel, opened from a button. Yields its parts. */
class Popover extends Component<{
  Args: {
    /** Whether the popover is open. Pass it with `@onOpenChange` to control it. */
    open?: boolean
    /** Whether the popover starts open, when uncontrolled. */
    defaultOpen?: boolean
    /** `false` keeps the page usable, `true` traps focus and makes the page inert, `"trap-focus"` only traps focus. */
    modal?: boolean | "trap-focus"
    /** Whether resting the pointer on the trigger opens the popover. */
    openOnHover?: boolean
    /** Milliseconds the pointer rests on the trigger before the popover opens. */
    delay?: number
    /** Milliseconds before the popover closes once the pointer leaves it. */
    closeDelay?: number
    /** How the popover presents: a popover, a sheet, or `"auto"`. */
    presentation?: "auto" | "popover" | "sheet"
    /** Opens, closes and inspects the popover from anywhere. */
    controller?: object
    /** Whether Escape, an outside press and the like can close the popover. */
    dismissible?: boolean
    /** Logs every state change with its reason. */
    debug?: boolean
    /** Renders the popup into this element instead of in place. */
    container?: Element | DocumentFragment | null
    /** Runs when the popover wants to open or close. `details.cancel()` stops it. */
    onOpenChange?: (open: boolean, details: ChangeDetails<string>) => void
    /** Runs once the popover has finished opening or closing. */
    onOpenChangeComplete?: (open: boolean) => void
    /** Runs when the payload the content shows changes. */
    onPayloadChange?: (payload: unknown, details: ChangeDetails<string>) => void
    /** Runs when `dismissible` refused a dismissal made on purpose. */
    onDismissAttempt?: (details: ChangeDetails<string>) => void
  }
  Blocks: { default: [Record<string, any>] }
}> {
  handle = usePrimitive(this, popover)

  constructor(owner: Owner, args: Popover["args"]) {
    super(owner, args)
    registerController(this, () => this.args.controller, this.handle)
  }

  <template>
    {{syncOptions this.handle}}
    {{yield
      (hash
        handle=this.handle
        Trigger=(component PopoverTrigger handle=this.handle)
        Content=(component
          PopoverContent handle=this.handle rootContainer=@container
        )
        Title=(component PopoverTitle handle=this.handle)
        Description=(component PopoverDescription handle=this.handle)
        Close=(component PopoverClose handle=this.handle)
        Arrow=(component PopoverArrow handle=this.handle)
        Shortcut=(component PopoverShortcut handle=this.handle)
      )
    }}
  </template>
}

export default Popover
