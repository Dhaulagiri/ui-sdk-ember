import type { ChangeDetails } from "@ui-sdk/core"
import { useFieldValues, type FieldContext } from "../field/context"
import Component from "@glimmer/component"
import {
  numberInput,
  type NumberInputOptions,
  type NumberInputValueChangeReason,
} from "@ui-sdk/core/number-input"
import { registerController } from "../controller-target"
import { usePart } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import NumberInputGroup from "./number-input-group.gts"
import NumberInputControl from "./number-input-control.gts"
import NumberInputIncrement from "./number-input-increment.gts"
import NumberInputDecrement from "./number-input-decrement.gts"
import NumberInputScrubArea from "./number-input-scrub-area.gts"
import NumberInputScrubAreaCursor from "./number-input-scrub-area-cursor.gts"

/** The root, and the hidden input that submits the number as is. Yields its parts. */
class NumberInput extends Component<{
  Element: HTMLDivElement
  Args: {
    /** The number, or null while the field is empty. Pass it with `@onValueChange` to control the field. */
    value?: number | null
    /** The number at first, when uncontrolled. A form reset returns to it. */
    defaultValue?: number | null
    /** The smallest value. */
    min?: number
    /** The largest value. */
    max?: number
    /** How much the buttons and arrow keys change the value. */
    step?: number
    /** How much Shift or Page Up and Down change the value. */
    largeStep?: number
    /** How much Alt changes the value. */
    smallStep?: number
    /** How the value formats, as `Intl.NumberFormat` options. */
    format?: NumberInputOptions["format"]
    /** The locale the value formats and parses in. */
    locale?: string
    /** Whether the mouse wheel changes the value while the field is focused. */
    wheel?: boolean
    /** Stops input. */
    disabled?: boolean
    /** Keeps it focusable and submitted, but the value doesn't change. */
    readOnly?: boolean
    /** Blocks form submission while it's empty. */
    required?: boolean
    /** The name it submits under. */
    name?: string
    /** The id of a form to belong to, when it isn't inside that form. */
    form?: string
    /** Changes the value from anywhere, and connects scrub areas outside the field. Create one with `createNumberInputController()`. */
    controller?: NumberInputOptions["controller"]
    /** Logs every state change with its reason. */
    debug?: boolean
    /** Runs when the value wants to change. `details.cancel()` stops it. */
    onValueChange?: (
      value: number | null,
      details: ChangeDetails<NumberInputValueChangeReason>
    ) => void
    /** Runs when the value is committed, on blur or Enter. */
    onValueCommit?: NumberInputOptions["onValueCommit"]
    /** The Field around it, as its `field` yields. */
    field?: FieldContext
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: { default: [Record<string, any>] }
}> {
  fieldValues = useFieldValues(this)
  handle = usePrimitive(this, numberInput, () => ({
    name: this.args.name ?? this.fieldValues.name,
    disabled: this.args.disabled || this.fieldValues.disabled,
    controlId: this.fieldValues.controlId,
  }))
  root = usePart(this, () => this.handle, "root")
  hidden = usePart(this, () => this.handle, "hidden-input")
  registered = registerController(this, () => this.args.controller, this.handle)

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        Group=(component NumberInputGroup handle=this.handle)
        Control=(component NumberInputControl handle=this.handle field=@field)
        Increment=(component NumberInputIncrement handle=this.handle)
        Decrement=(component NumberInputDecrement handle=this.handle)
        ScrubArea=(component NumberInputScrubArea handle=this.handle)
        ScrubAreaCursor=(component
          NumberInputScrubAreaCursor handle=this.handle
        )
      )
      as |n|
    }}
      {{#if @render}}
        {{yield n}}
      {{else}}
        <div ...attributes {{this.root.modifier}}>{{yield n}}</div>
      {{/if}}
    {{/let}}
    <input {{this.hidden.modifier}} />
  </template>
}

export default NumberInput
