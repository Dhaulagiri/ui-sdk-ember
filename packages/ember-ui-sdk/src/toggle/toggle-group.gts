import { hash } from "@ember/helper"
import Component from "@glimmer/component"
import type { ChangeDetails } from "@ui-sdk/core"
import {
  toggleGroup,
  type ToggleGroupController,
  type ToggleGroupOrientation,
  type ToggleGroupValueChangeReason,
} from "@ui-sdk/core/toggle"
import { usePart } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import Toggle from "./toggle.gts"

/** Toggles that share one value, with one tab stop and arrow keys between them. Yields its `Toggle`. */
class ToggleGroup extends Component<{
  Element: HTMLDivElement
  Args: {
    /** The pressed values. Pass it with `@onValueChange` to control the group. */
    value?: string[]
    /** The pressed values at first, when uncontrolled. */
    defaultValue?: string[]
    /** Whether several toggles can be pressed at once. */
    multiple?: boolean
    /** Whether pressing the only pressed toggle clears it, in a single-value group. */
    deselectable?: boolean
    /** Disables every toggle in the group. */
    disabled?: boolean
    /** Which arrow keys move between toggles. */
    orientation?: ToggleGroupOrientation
    /** Whether arrow keys wrap from the last toggle to the first. */
    loop?: boolean
    /** Changes the value from anywhere. Create one with `createToggleGroupController()`. */
    controller?: ToggleGroupController
    /** Logs every state change with its reason. */
    debug?: boolean
    /** Runs when a toggle wants to change the value. `details.cancel()` stops it. */
    onValueChange?: (
      value: string[],
      details: ChangeDetails<ToggleGroupValueChangeReason>
    ) => void
    /** The handle of the Toolbar around it, which a toolbar's yielded `ToggleGroup` passes. */
    toolbar?: { api: { internal: { scopeIn: (disabled: boolean) => any } } }
    /** Whether the toolbar group around it is disabled. */
    groupDisabled?: boolean
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: { default: [Record<string, any>] }
}> {
  handle = usePrimitive(this, toggleGroup, () => ({
    toolbar: this.args.toolbar
      ? () => this.args.toolbar!.api.internal.scopeIn(!!this.args.groupDisabled)
      : undefined,
  }))
  root = usePart(this, () => this.handle, "group")

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        Toggle=(component
          Toggle group=this.handle toolbar=@toolbar groupDisabled=@groupDisabled
        )
      )
      as |g|
    }}
      {{#if @render}}
        {{yield g}}
      {{else}}
        <div ...attributes {{this.root.modifier}}>{{yield g}}</div>
      {{/if}}
    {{/let}}
  </template>
}

export default ToggleGroup
