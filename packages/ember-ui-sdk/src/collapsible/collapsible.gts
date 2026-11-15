import type { ChangeDetails } from "@ui-sdk/core"
import Component from "@glimmer/component"
import {
  collapsible,
  type CollapsibleController,
  type CollapsibleOpenChangeReason,
} from "@ui-sdk/core/collapsible"
import { usePart } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import CollapsibleTrigger from "./collapsible-trigger.gts"
import CollapsiblePanel from "./collapsible-panel.gts"

/** A panel of content that a button shows and hides. Yields its trigger and panel. */
class Collapsible extends Component<{
  Element: HTMLDivElement
  Args: {
    /** Whether the panel is open. Pass it with `@onOpenChange` to control it. */
    open?: boolean
    /** Whether the panel is open at first, when uncontrolled. */
    defaultOpen?: boolean
    /** Stops the trigger from toggling the panel. */
    disabled?: boolean
    /** Opens and closes it from anywhere. Create one with `createCollapsibleController()`. */
    controller?: CollapsibleController
    /** Logs every state change with its reason. */
    debug?: boolean
    /** Runs when the panel wants to open or close. `details.cancel()` stops it. */
    onOpenChange?: (
      open: boolean,
      details: ChangeDetails<CollapsibleOpenChangeReason>
    ) => void
    /** Runs once the panel finished opening or closing, animations included. */
    onOpenChangeComplete?: (open: boolean) => void
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: { default: [Record<string, any>] }
}> {
  handle = usePrimitive(this, collapsible)
  root = usePart(this, () => this.handle, "root")

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        Trigger=(component CollapsibleTrigger handle=this.handle)
        Panel=(component CollapsiblePanel handle=this.handle)
      )
      as |c|
    }}
      {{#if @render}}
        {{yield c}}
      {{else}}
        <div ...attributes {{this.root.modifier}}>{{yield c}}</div>
      {{/if}}
    {{/let}}
  </template>
}

export default Collapsible
