import { hash } from "@ember/helper"
import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { tooltip } from "@ui-sdk/core/tooltip"
import { registerController } from "../controller-target"
import { syncOptions, usePrimitive } from "../use-primitive"
import TooltipArrow from "./tooltip-arrow.gts"
import TooltipContent from "./tooltip-content.gts"
import TooltipShortcut from "./tooltip-shortcut.gts"
import TooltipTrigger from "./tooltip-trigger.gts"

/** A short label or hint that appears when the pointer rests on its trigger or keyboard focus reaches it. Yields its parts. */
class Tooltip extends Component<{
  Args: Record<string, unknown> & {
    /** Opens, closes and inspects the tooltip from anywhere, and connects triggers outside it. */
    controller?: object
    /** Renders the popup into this element instead of in place. */
    container?: Element | DocumentFragment | null
  }
  Blocks: { default: [Record<string, any>] }
}> {
  handle = usePrimitive(this, tooltip)

  constructor(owner: Owner, args: Tooltip["args"]) {
    super(owner, args)
    registerController(this, () => this.args.controller, this.handle)
  }

  <template>
    {{syncOptions this.handle}}
    {{yield
      (hash
        handle=this.handle
        Trigger=(component TooltipTrigger handle=this.handle)
        Content=(component
          TooltipContent handle=this.handle rootContainer=@container
        )
        Arrow=(component TooltipArrow handle=this.handle)
        Shortcut=(component TooltipShortcut handle=this.handle)
      )
    }}
  </template>
}

export default Tooltip
