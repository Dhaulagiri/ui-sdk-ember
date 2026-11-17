import { hash } from "@ember/helper"
import Component from "@glimmer/component"
import type { ChangeDetails } from "@ui-sdk/core"
import {
  toggle,
  type ToggleController,
  type TogglePressedChangeReason,
} from "@ui-sdk/core/toggle"
import { usePart } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import ToggleIcon from "./toggle-icon.gts"

/** A button that stays pressed. Inside a ToggleGroup, the group decides whether it's pressed. */
class Toggle extends Component<{
  Element: HTMLButtonElement
  Args: {
    /** Whether it's pressed. Pass it with `@onPressedChange` to control the toggle. */
    pressed?: boolean
    /** Whether it's pressed at first, when uncontrolled. */
    defaultPressed?: boolean
    /** Identifies the toggle inside a group, whose value lists the pressed toggles' values. */
    value?: string
    /** Stops presses. */
    disabled?: boolean
    /** Keeps a disabled toggle in the tab order with `aria-disabled`. */
    focusableWhenDisabled?: boolean
    /** Presses the toggle from anywhere. Create one with `createToggleController()`. */
    controller?: ToggleController
    /** Logs every state change with its reason. */
    debug?: boolean
    /** Runs when a press wants to change it. `details.cancel()` stops it. */
    onPressedChange?: (
      pressed: boolean,
      details: ChangeDetails<TogglePressedChangeReason>
    ) => void
    /** The handle of the ToggleGroup around it, which its group's yielded `Toggle` passes. */
    group?: { api: { internal: object } }
    /** The handle of the Toolbar around it, which a toolbar's yielded `Toggle` passes. */
    toolbar?: { api: { internal: { scopeIn: (disabled: boolean) => any } } }
    /** Whether the toolbar group around it is disabled. */
    groupDisabled?: boolean
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: { default: [Record<string, any>] }
}> {
  handle = usePrimitive(this, toggle, () => ({
    group: this.args.group ? () => (this.args.group as any).api : undefined,
    toolbar: this.args.toolbar
      ? () => this.args.toolbar!.api.internal.scopeIn(!!this.args.groupDisabled)
      : undefined,
  }))
  root = usePart(this, () => this.handle, "root")

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        Icon=(component ToggleIcon handle=this.handle)
      )
      as |t|
    }}
      {{#if @render}}
        {{yield t}}
      {{else}}
        <button ...attributes {{this.root.modifier}}>{{yield t}}</button>
      {{/if}}
    {{/let}}
  </template>
}

export default Toggle
