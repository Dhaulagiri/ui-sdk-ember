import Component from "@glimmer/component"
import type { ChangeDetails } from "@ui-sdk/core"
import {
  checkboxGroup,
  type CheckboxGroupController,
  type CheckboxGroupValueChangeReason,
} from "@ui-sdk/core/checkbox"
import { useFieldControl, type FieldContext } from "../field/context"
import { usePart } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import Checkbox from "./checkbox.gts"

/** Checkboxes that share a name and a list of checked values. The group, not each checkbox, sits in a field. Yields its `Checkbox`. */
class CheckboxGroup extends Component<{
  Element: HTMLDivElement
  Args: {
    /** The checked values. Pass it with `@onValueChange` to control the group. */
    value?: string[]
    /** The checked values at first, when uncontrolled. A form reset returns to them. */
    defaultValue?: string[]
    /** Every value in the group, for a parent checkbox to check them all. */
    allValues?: string[]
    /** Disables every checkbox in the group. */
    disabled?: boolean
    /** Makes every checkbox in the group read-only. */
    readOnly?: boolean
    /** Blocks form submission until a value is checked. */
    required?: boolean
    /** The name the values submit under. */
    name?: string
    /** The id of a form to belong to, when it isn't inside that form. */
    form?: string
    /** Drives the group from anywhere. Create one with `createCheckboxGroupController()`. */
    controller?: CheckboxGroupController
    /** Logs every state change with its reason. */
    debug?: boolean
    /** Runs when a checkbox or a form reset wants to change the values. `details.cancel()` stops it. */
    onValueChange?: (
      value: string[],
      details: ChangeDetails<CheckboxGroupValueChangeReason>
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
  handle = usePrimitive(this, checkboxGroup, () => ({
    disabled: this.args.disabled || this.fieldControl.disabled,
    name: this.args.name ?? this.fieldControl.name,
  }))
  root = usePart(this, () => this.handle, "group")
  input = usePart(this, () => this.handle, "group-input")

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        Checkbox=(component Checkbox group=this.handle)
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
    <input {{this.input.modifier}} />
  </template>
}

export default CheckboxGroup
