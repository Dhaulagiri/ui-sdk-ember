import { hash } from "@ember/helper"
import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { hoverCard } from "@ui-sdk/core/hover-card"
import { registerController } from "../controller-target"
import { syncOptions, usePrimitive } from "../use-primitive"
import HoverCardArrow from "./hover-card-arrow.gts"
import HoverCardContent from "./hover-card-content.gts"
import HoverCardTrigger from "./hover-card-trigger.gts"

/** A preview of what a link points to, shown when the pointer rests on the link or keyboard focus stays on it. Yields its parts. */
class HoverCard extends Component<{
  Args: Record<string, unknown> & {
    /** Opens, closes and inspects the card from anywhere, and connects triggers outside it. */
    controller?: object
    /** Renders the popup into this element instead of in place. */
    container?: Element | DocumentFragment | null
  }
  Blocks: { default: [Record<string, any>] }
}> {
  handle = usePrimitive(this, hoverCard)

  constructor(owner: Owner, args: HoverCard["args"]) {
    super(owner, args)
    registerController(this, () => this.args.controller, this.handle)
  }

  <template>
    {{syncOptions this.handle}}
    {{yield
      (hash
        handle=this.handle
        Trigger=(component HoverCardTrigger handle=this.handle)
        Content=(component
          HoverCardContent handle=this.handle rootContainer=@container
        )
        Arrow=(component HoverCardArrow handle=this.handle)
      )
    }}
  </template>
}

export default HoverCard
