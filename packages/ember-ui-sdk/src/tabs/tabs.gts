import { hash } from "@ember/helper"
import type { WithBoundArgs } from "@glint/template"
import Component from "@glimmer/component"
import type { ChangeDetails } from "@ui-sdk/core"
import { tabs } from "@ui-sdk/core/tabs"
import { usePart, type RootYield } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import TabsIndicator from "./tabs-indicator.gts"
import TabsList from "./tabs-list.gts"
import TabsPanel from "./tabs-panel.gts"
import TabsTab from "./tabs-tab.gts"
import TabsTabIcon from "./tabs-tab-icon.gts"

/** Layered sections of content, one shown at a time. Yields its parts. */
class Tabs extends Component<{
  Element: HTMLDivElement
  Args: {
    /** The selected tab's value. Pass it with `@onValueChange` to control the tabs. */
    value?: string | null
    /** The tab selected at first, when uncontrolled. */
    defaultValue?: string | null
    /** Which arrow keys move between tabs. */
    orientation?: "horizontal" | "vertical"
    /** `"automatic"` selects a tab as arrow keys focus it, `"manual"` waits for Enter or Space. */
    activation?: "automatic" | "manual"
    /** Whether arrow keys wrap from the last tab to the first. */
    loop?: boolean
    /** Keeps hidden panels in the page as `hidden="until-found"`. */
    hiddenUntilFound?: boolean
    /** Selects tabs from anywhere. Create one with `createTabsController()`. */
    controller?: object
    /** Logs every state change with its reason. */
    debug?: boolean
    /** Runs when the selection wants to change. `details.cancel()` stops it. */
    onValueChange?: (
      value: string | null,
      details: ChangeDetails<string>
    ) => void
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: {
    default: [
      RootYield<typeof tabs> & {
        List: WithBoundArgs<typeof TabsList, "handle">
        Tab: WithBoundArgs<typeof TabsTab, "handle">
        TabIcon: WithBoundArgs<typeof TabsTabIcon, "handle">
        Panel: WithBoundArgs<typeof TabsPanel, "handle">
        Indicator: WithBoundArgs<typeof TabsIndicator, "handle">
      },
    ]
  }
}> {
  handle = usePrimitive(this, tabs)
  root = usePart(this, () => this.handle, "root")

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        List=(component TabsList handle=this.handle)
        Tab=(component TabsTab handle=this.handle)
        TabIcon=(component TabsTabIcon handle=this.handle)
        Panel=(component TabsPanel handle=this.handle)
        Indicator=(component TabsIndicator handle=this.handle)
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

export default Tabs
