import { hash } from "@ember/helper"
import Component from "@glimmer/component"
import type { ChangeDetails } from "@ui-sdk/core"
import {
  switchPrimitive,
  type SwitchCheckedChangeReason,
  type SwitchController,
} from "@ui-sdk/core/switch"
import { useFieldControl, type FieldContext } from "../field/context"
import { usePart } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import SwitchThumb from "./switch-thumb.gts"

/** A control that turns a setting on or off, with the hidden native input that takes part in the form. */
class Switch extends Component<{
  Element: HTMLButtonElement
  Args: {
    /** Whether it's on. Pass it with `@onCheckedChange` to control the switch. */
    checked?: boolean
    /** Whether it's on at first, when uncontrolled. A form reset returns to it. */
    defaultChecked?: boolean
    /** Toggles it from anywhere. Create one with `createSwitchController()`. */
    controller?: SwitchController
    /** Stops presses. */
    disabled?: boolean
    /** Keeps it focusable and submitted, but presses don't change it. */
    readOnly?: boolean
    /** Blocks form submission until it's on. */
    required?: boolean
    /** The name it submits under. */
    name?: string
    /** The value it submits while on. */
    value?: string
    /** The id of a form to belong to, when it isn't inside that form. */
    form?: string
    /** Logs every state change with its reason. */
    debug?: boolean
    /** Runs when a user or a form reset wants to change it. `details.cancel()` stops it. */
    onCheckedChange?: (
      checked: boolean,
      details: ChangeDetails<SwitchCheckedChangeReason>
    ) => void
    /** Its id, which a Field's label points at. */
    id?: string
    /** The Field around it, as its `field` yields. */
    field?: FieldContext
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: { default: [Record<string, any>] }
}> {
  fieldControl = useFieldControl(this, () => ({ id: this.args.id }))
  handle = usePrimitive(this, switchPrimitive, () => ({
    disabled: this.args.disabled || this.fieldControl.disabled,
    name: this.args.name ?? this.fieldControl.name,
  }))
  root = usePart(this, () => this.handle, "root")
  input = usePart(this, () => this.handle, "input")

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        Thumb=(component SwitchThumb handle=this.handle)
      )
      as |s|
    }}
      {{#if @render}}
        {{yield s}}
      {{else}}
        <button
          id={{@id}}
          ...attributes
          {{this.root.modifier}}
          {{this.fieldControl.modifier}}
        >{{yield s}}</button>
      {{/if}}
    {{/let}}
    <input {{this.input.modifier}} />
  </template>
}

export default Switch
