import { hash } from "@ember/helper"
import Component from "@glimmer/component"
import type { ChangeDetails } from "@ui-sdk/core"
import {
  radioGroup,
  type RadioGroupController,
  type RadioGroupValueChangeReason,
} from "@ui-sdk/core/radio"
import { useFieldControl, type FieldContext } from "../field/context"
import { usePart } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import Radio from "./radio.gts"

/** Radios that share one value, with one tab stop and arrow keys between them. Yields its `Radio`. */
class RadioGroup extends Component<{
  Element: HTMLDivElement
  Args: {
    /** The checked radio's value. Pass it with `@onValueChange` to control the group. */
    value?: string | null
    /** The checked radio's value at first, when uncontrolled. A form reset returns to it. */
    defaultValue?: string | null
    /** Disables every radio in the group. */
    disabled?: boolean
    /** Keeps the group focusable and submitted, but presses don't change it. */
    readOnly?: boolean
    /** Blocks form submission until a radio is checked. */
    required?: boolean
    /** The name the value submits under. */
    name?: string
    /** The id of a form to belong to, when it isn't inside that form. */
    form?: string
    /** Whether arrow keys wrap from the last radio to the first. */
    loop?: boolean
    /** Drives the group from anywhere. Create one with `createRadioGroupController()`. */
    controller?: RadioGroupController
    /** Logs every state change with its reason. */
    debug?: boolean
    /** Runs when a radio wants to change the value. `details.cancel()` stops it. */
    onValueChange?: (
      value: string | null,
      details: ChangeDetails<RadioGroupValueChangeReason>
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
  handle = usePrimitive(this, radioGroup, () => ({
    disabled: this.args.disabled || this.fieldControl.disabled,
    name: this.args.name ?? this.fieldControl.name,
  }))
  root = usePart(this, () => this.handle, "group")

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        Radio=(component Radio handle=this.handle)
      )
      as |g|
    }}
      {{#if @render}}
        {{yield g}}
      {{else}}
        <div
          id={{@id}}
          ...attributes
          {{this.root.modifier}}
          {{this.fieldControl.modifier}}
        >{{yield g}}</div>
      {{/if}}
    {{/let}}
  </template>
}

export default RadioGroup
