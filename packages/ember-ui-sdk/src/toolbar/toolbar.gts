import { hash } from "@ember/helper"
import type { WithBoundArgs } from "@glint/template"
import Component from "@glimmer/component"
import {
  toolbar,
  type ToolbarController,
  type ToolbarOrientation,
} from "@ui-sdk/core/toolbar"
import { usePart, type RootYield } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import ToolbarGroup from "./toolbar-group.gts"
import ToolbarButton from "./toolbar-button.gts"
import ToolbarLink from "./toolbar-link.gts"
import ToolbarInput from "./toolbar-input.gts"
import ToolbarSeparator from "./toolbar-separator.gts"
import Toggle from "../toggle/toggle.gts"
import ToggleGroup from "../toggle/toggle-group.gts"

/** A row of controls with one tab stop and arrow keys between them. Toggles and toggle groups inside join it through its yielded `Toggle` and `ToggleGroup`. Render menu and select triggers through `Button`, and fields through `Input`, with `@render`. */
class Toolbar extends Component<{
  Element: HTMLDivElement
  Args: {
    /** Which arrow keys move between items. */
    orientation?: ToolbarOrientation
    /** Whether arrow keys wrap from the last item to the first. */
    loop?: boolean
    /** Disables every item. */
    disabled?: boolean
    /** Moves focus into the toolbar from anywhere. Create one with `createToolbarController()`. */
    controller?: ToolbarController
    /** Logs every state change with its reason. */
    debug?: boolean
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: {
    default: [
      RootYield<typeof toolbar> & {
        Group: WithBoundArgs<typeof ToolbarGroup, "handle">
        Button: WithBoundArgs<typeof ToolbarButton, "handle">
        Link: WithBoundArgs<typeof ToolbarLink, "handle">
        Input: WithBoundArgs<typeof ToolbarInput, "handle">
        Separator: WithBoundArgs<typeof ToolbarSeparator, "handle">
        Toggle: WithBoundArgs<typeof Toggle, "toolbar">
        ToggleGroup: WithBoundArgs<typeof ToggleGroup, "toolbar">
      },
    ]
  }
}> {
  handle = usePrimitive(this, toolbar)
  root = usePart(this, () => this.handle, "root")

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        Group=(component ToolbarGroup handle=this.handle)
        Button=(component ToolbarButton handle=this.handle)
        Link=(component ToolbarLink handle=this.handle)
        Input=(component ToolbarInput handle=this.handle)
        Separator=(component ToolbarSeparator handle=this.handle)
        Toggle=(component Toggle toolbar=this.handle)
        ToggleGroup=(component ToggleGroup toolbar=this.handle)
      )
      as |t|
    }}
      {{#if @render}}
        {{yield t}}
      {{else}}
        <div ...attributes {{this.root.modifier}}>{{yield t}}</div>
      {{/if}}
    {{/let}}
  </template>
}

export default Toolbar
