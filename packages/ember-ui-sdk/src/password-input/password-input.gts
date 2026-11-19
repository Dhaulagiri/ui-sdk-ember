import { hash } from "@ember/helper"
import type { WithBoundArgs } from "@glint/template"
import Component from "@glimmer/component"
import type { ChangeDetails } from "@ui-sdk/core"
import {
  passwordInput,
  type InputValueChangeReason,
  type PasswordInputOptions,
  type PasswordInputVisibleChangeReason,
} from "@ui-sdk/core/password-input"
import { useFieldValues, type FieldContext } from "../field/context"
import { usePart, type RootYield } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import PasswordInputControl from "./password-input-control.gts"
import PasswordInputToggle from "./password-input-toggle.gts"

/** Holds the field and its toggle. Presses on its own text and icons focus the field. Yields its `Control` and `Toggle`. */
class PasswordInput extends Component<{
  Element: HTMLDivElement
  Args: {
    /** The password. Pass it with `@onValueChange` to control the field. */
    value?: string
    /** The password at first, when uncontrolled. A form reset returns to it. */
    defaultValue?: string
    /** Whether the password shows. Pass it with `@onVisibleChange` to control it. */
    visible?: boolean
    /** Whether the password shows at first, when uncontrolled. */
    defaultVisible?: boolean
    /** What the browser may fill in. */
    autoComplete?: PasswordInputOptions["autoComplete"]
    /** The name it submits under. */
    name?: string
    /** The id of a form to belong to, when it isn't inside that form. */
    form?: string
    /** Blocks form submission while it's empty. */
    required?: boolean
    /** Stops input. */
    disabled?: boolean
    /** Keeps it focusable and submitted, but the text doesn't change. */
    readOnly?: boolean
    /** Changes the text from anywhere. Create one with `createPasswordInputController()`. */
    controller?: PasswordInputOptions["controller"]
    /** Logs every state change with its reason. */
    debug?: boolean
    /** Runs when the text wants to change. `details.cancel()` stops it. */
    onValueChange?: (
      value: string,
      details: ChangeDetails<InputValueChangeReason>
    ) => void
    /** Runs when the password wants to show or hide. `details.cancel()` stops it. */
    onVisibleChange?: (
      visible: boolean,
      details: ChangeDetails<PasswordInputVisibleChangeReason>
    ) => void
    /** The Field around it, as its `field` yields. */
    field?: FieldContext
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: {
    default: [
      RootYield<typeof passwordInput> & {
        Control: WithBoundArgs<
          typeof PasswordInputControl,
          "handle" | "field" | "value" | "defaultValue"
        >
        Toggle: WithBoundArgs<typeof PasswordInputToggle, "handle">
      },
    ]
  }
}> {
  fieldValues = useFieldValues(this)
  handle = usePrimitive(this, passwordInput, () => ({
    name: this.args.name ?? this.fieldValues.name,
    disabled: this.args.disabled || this.fieldValues.disabled,
    controlId: this.fieldValues.controlId,
  }))
  root = usePart(this, () => this.handle, "root")

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        Control=(component
          PasswordInputControl
          handle=this.handle
          field=@field
          value=@value
          defaultValue=@defaultValue
        )
        Toggle=(component PasswordInputToggle handle=this.handle)
      )
      as |p|
    }}
      {{#if @render}}
        {{yield p}}
      {{else}}
        <div ...attributes {{this.root.modifier}}>{{yield p}}</div>
      {{/if}}
    {{/let}}
  </template>
}

export default PasswordInput
