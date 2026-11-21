import { hash } from "@ember/helper"
import type { WithBoundArgs } from "@glint/template"
import Component from "@glimmer/component"
import type { ChangeDetails } from "@ui-sdk/core"
import {
  checkbox,
  type CheckboxCheckedChangeReason,
  type CheckboxController,
  type CheckedState,
} from "@ui-sdk/core/checkbox"
import { useFieldControl, type FieldContext } from "../field/context"
import { usePart, type RootYield } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import CheckboxIndicator from "./checkbox-indicator.gts"

/** The control and the hidden native input that takes part in the form. */
class Checkbox extends Component<{
  Element: HTMLButtonElement
  Args: {
    /** Whether it's checked. Pass it with `@onCheckedChange` to control the checkbox. */
    checked?: CheckedState
    /** Whether it's checked at first, when uncontrolled. A form reset returns to it. */
    defaultChecked?: CheckedState
    /** Makes it the parent of its group: checked when every value is, indeterminate for some. */
    parent?: boolean
    /** Toggles it from anywhere. Create one with `createCheckboxController()`. */
    controller?: CheckboxController
    /** Stops presses. */
    disabled?: boolean
    /** Keeps it focusable and submitted, but presses don't change it. */
    readOnly?: boolean
    /** Blocks form submission until it's checked. */
    required?: boolean
    /** The name it submits under. */
    name?: string
    /** The value it submits while checked, and its value in a group. */
    value?: string
    /** The id of a form to belong to, when it isn't inside that form. */
    form?: string
    /** Logs every state change with its reason. */
    debug?: boolean
    /** Runs when a user or a form reset wants to change it. `details.cancel()` stops it. */
    onCheckedChange?: (
      checked: CheckedState,
      details: ChangeDetails<CheckboxCheckedChangeReason>
    ) => void
    /** Its id, which a Field's label points at. */
    id?: string
    /** The Field around it, as its `field` yields. */
    field?: FieldContext
    /** The handle of the CheckboxGroup around it, which the group's yielded `Checkbox` passes. */
    group?: { api: object }
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: {
    default: [
      RootYield<typeof checkbox> & {
        Indicator: WithBoundArgs<typeof CheckboxIndicator, "handle">
      },
    ]
  }
}> {
  fieldControl = useFieldControl(this, () => ({ id: this.args.id }))
  handle = usePrimitive(this, checkbox, () => ({
    group: (this.args.group ? () => this.args.group!.api : undefined) as never,
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
        Indicator=(component CheckboxIndicator handle=this.handle)
      )
      as |c|
    }}
      {{#if @render}}
        {{yield c}}
      {{else}}
        <button
          id={{@id}}
          ...attributes
          {{this.root.modifier}}
          {{this.fieldControl.modifier}}
        >{{yield c}}</button>
      {{/if}}
    {{/let}}
    <input {{this.input.modifier}} />
  </template>
}

export default Checkbox
