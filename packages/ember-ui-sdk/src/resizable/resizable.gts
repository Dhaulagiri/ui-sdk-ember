import { hash } from "@ember/helper"
import Component from "@glimmer/component"
import { resizable, type ResizableOptions } from "@ui-sdk/core/resizable"
import { usePart } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import ResizableHandle from "./resizable-handle.gts"
import ResizablePanel from "./resizable-panel.gts"

/** The group: lays its panels out along its orientation. Yields its `Panel` and `Handle`. */
class Resizable extends Component<{
  Element: HTMLDivElement
  Args: {
    /** Each panel's size in percent, in panel order. Pass it with `@onLayoutChange` to control the group. */
    layout?: number[]
    /** The layout at first, when uncontrolled. */
    defaultLayout?: number[]
    /** The direction panels are laid out in. */
    orientation?: "horizontal" | "vertical"
    /** Stops every handle: no drags, no keys, and handles leave the tab order. */
    disabled?: boolean
    /** How far an arrow key moves a handle, in percent. */
    step?: number
    /** How far Shift with an arrow key moves a handle, in percent. */
    largeStep?: number
    /** Saves the layout when an interaction completes and restores it on the next visit, under this key. */
    autoSaveId?: string
    /** Where `autoSaveId` saves: anything with `getItem` and `setItem`. */
    storage?: object
    /** Resizes the group from anywhere. Create one with `createResizableController()`. */
    controller?: object
    /** Logs every layout change with its reason. */
    debug?: boolean
    /** Runs while the layout changes. `details.cancel()` keeps the layout. */
    onLayoutChange?: ResizableOptions["onLayoutChange"]
    /** Runs once an interaction that changed the layout ends. For saving. */
    onLayoutCommit?: ResizableOptions["onLayoutCommit"]
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: { default: [Record<string, any>] }
}> {
  handle = usePrimitive(this, resizable)
  root = usePart(this, () => this.handle, "root")

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        Panel=(component ResizablePanel handle=this.handle)
        Handle=(component ResizableHandle handle=this.handle)
      )
      as |r|
    }}
      {{#if @render}}
        {{yield r}}
      {{else}}
        <div ...attributes {{this.root.modifier}}>{{yield r}}</div>
      {{/if}}
    {{/let}}
  </template>
}

export default Resizable
