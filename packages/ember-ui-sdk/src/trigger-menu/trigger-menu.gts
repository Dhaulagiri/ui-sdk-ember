import { hash } from "@ember/helper"
import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { triggerMenu } from "@ui-sdk/core/trigger-menu"
import { registerController } from "../controller-target"
import { syncOptions, usePrimitive } from "../use-primitive"
import TriggerMenuContent from "./trigger-menu-content.gts"
import TriggerMenuEmpty from "./trigger-menu-empty.gts"
import TriggerMenuGroup from "./trigger-menu-group.gts"
import TriggerMenuHint from "./trigger-menu-hint.gts"
import TriggerMenuInput from "./trigger-menu-input.gts"
import TriggerMenuItem from "./trigger-menu-item.gts"
import TriggerMenuItems from "./trigger-menu-items.gts"
import TriggerMenuList from "./trigger-menu-list.gts"
import TriggerMenuSeparator from "./trigger-menu-separator.gts"
import TriggerMenuStatus from "./trigger-menu-status.gts"

// Whether the app renders a content of its own, so the menu knows whether to render one.
class Shared {
  contents = 0
}

/**
 * A menu of suggestions that opens at a trigger character typed in a text
 * field, like `@` or `/`. It renders no element of its own. Takes TriggerMenu's
 * options as arguments, and yields its parts.
 */
class TriggerMenu extends Component<{
  Args: Record<string, unknown> & {
    /** The triggers, and what each one suggests. */
    triggers: unknown[]
    /** Reads and sets the menu from anywhere. */
    controller?: object
    /** Renders the popup into this element instead of in place. */
    container?: Element | DocumentFragment | null
  }
  Blocks: { default: [Record<string, any>] }
}> {
  handle = usePrimitive(this, triggerMenu)
  shared = new Shared()

  constructor(owner: Owner, args: TriggerMenu["args"]) {
    super(owner, args)
    registerController(this, () => this.args.controller, this.handle)
  }

  get ownContent() {
    return this.shared.contents > 0
  }

  <template>
    {{syncOptions this.handle}}
    {{yield
      (hash
        handle=this.handle
        Input=(component TriggerMenuInput handle=this.handle)
        Hint=(component TriggerMenuHint handle=this.handle)
        Status=(component TriggerMenuStatus handle=this.handle)
        Content=(component
          TriggerMenuContent
          handle=this.handle
          shared=this.shared
          rootContainer=@container
        )
        List=(component TriggerMenuList handle=this.handle)
        Items=(component TriggerMenuItems handle=this.handle)
        Item=(component TriggerMenuItem handle=this.handle)
        Group=(component TriggerMenuGroup handle=this.handle)
        Separator=(component TriggerMenuSeparator handle=this.handle)
        Empty=(component TriggerMenuEmpty handle=this.handle)
      )
    }}
    {{#unless this.ownContent}}
      <TriggerMenuContent
        @handle={{this.handle}}
        @shared={{this.shared}}
        @rootContainer={{@container}}
        @fromRoot={{true}}
      />
    {{/unless}}
  </template>
}

export default TriggerMenu
export { Shared }
