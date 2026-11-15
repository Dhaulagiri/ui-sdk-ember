import type { ChangeDetails } from "@ui-sdk/core"
import Component from "@glimmer/component"
import {
  otpInput,
  type OTPInputOptions,
  type OTPInputValueChangeReason,
} from "@ui-sdk/core/otp-input"
import { useFieldControl, type FieldContext } from "../field/context"
import { usePart } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import OTPInputGroup from "./otp-input-group.gts"
import OTPInputSeparator from "./otp-input-separator.gts"
import OTPInputSlot from "./otp-input-slot.gts"
import OTPInputControl from "./otp-input-control.gts"

/** The root: the slots, and the one real input over them. `@id`, `@autofocus` and the `@ariaLabel`, `@ariaLabelledby`, `@ariaDescribedby` and `@ariaInvalid` naming arguments go to that input. Yields its parts. */
class OTPInput extends Component<{
  Element: HTMLDivElement
  Args: {
    /** The code. Pass it with `@onValueChange` to control the input. */
    value?: string
    /** The code at first, when uncontrolled. */
    defaultValue?: string
    /** How many characters the code has. */
    maxLength?: OTPInputOptions["maxLength"]
    /** Which characters the code accepts. */
    pattern?: OTPInputOptions["pattern"]
    /** Which keyboard a touch device shows. */
    inputMode?: OTPInputOptions["inputMode"]
    /** Where the characters sit in the real input. */
    textAlign?: OTPInputOptions["textAlign"]
    /** What the browser may fill in. */
    autoComplete?: OTPInputOptions["autoComplete"]
    /** Stops input. */
    disabled?: boolean
    /** Keeps the code readable and focusable, but not editable. */
    readOnly?: boolean
    /** Blocks form submission until the code is complete. */
    required?: boolean
    /** The name the code submits under. */
    name?: string
    /** The id of a form to belong to, when it isn't inside that form. */
    form?: string
    /** The Field around it, as its `field` yields. */
    field?: FieldContext
    /** Drives the input from anywhere. Create one with `createOTPInputController()`. */
    controller?: OTPInputOptions["controller"]
    /** Logs every state change with its reason. */
    debug?: boolean
    /** Runs when the code wants to change. `details.cancel()` stops it. */
    onValueChange?: (
      value: string,
      details: ChangeDetails<OTPInputValueChangeReason>
    ) => void
    /** Runs once the code is complete. */
    onValueCommit?: OTPInputOptions["onValueCommit"]
    /** The real input's id. */
    id?: string
    /** Focuses the real input as the page loads. */
    autofocus?: boolean
    /** Names the real input. */
    ariaLabel?: string
    /** Names the real input by another element. */
    ariaLabelledby?: string
    /** Describes the real input. */
    ariaDescribedby?: string
    /** Whether the code is invalid. */
    ariaInvalid?: boolean | "true" | "false"
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: { default: [Record<string, any>] }
}> {
  fieldControl = useFieldControl(this, () => ({ id: this.args.id }))
  handle = usePrimitive(this, otpInput, () => ({
    disabled: this.args.disabled || this.fieldControl.disabled,
    name: this.args.name ?? this.fieldControl.name,
  }))
  root = usePart(this, () => this.handle, "root")

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        Group=(component OTPInputGroup handle=this.handle)
        Separator=(component OTPInputSeparator handle=this.handle)
        Slot=(component OTPInputSlot handle=this.handle)
        Input=(component
          OTPInputControl
          handle=this.handle
          id=@id
          autofocus=@autofocus
          fieldModifier=this.fieldControl.modifier
          ariaLabel=@ariaLabel
          ariaLabelledby=@ariaLabelledby
          ariaDescribedby=@ariaDescribedby
          ariaInvalid=@ariaInvalid
        )
      )
      as |o|
    }}
      {{#if @render}}
        {{yield o}}
      {{else}}
        <div ...attributes {{this.root.modifier}}>{{yield o}}<o.Input /></div>
      {{/if}}
    {{/let}}
  </template>
}

export default OTPInput
