import type { ChangeDetails } from "@ui-sdk/core"
import type {
  InputController,
  InputValueChangeReason,
} from "@ui-sdk/core/input"
import type { FieldContext } from "./field/context"

/**
 * The arguments a text field takes beside the attributes of its element.
 * @experimental
 */
type TextControlArgs = {
  /** The text. Pass it with `@onValueChange` to control the field. */
  value?: string
  /** The text at first, when uncontrolled. A form reset returns to it. */
  defaultValue?: string
  /** Stops input. */
  disabled?: boolean
  /** Keeps it focusable and submitted, but the text doesn't change. */
  readOnly?: boolean
  /** Blocks form submission while it's empty. */
  required?: boolean
  /** Changes the text from anywhere. Create one with `createInputController()`. */
  controller?: InputController
  /** Logs every state change with its reason. */
  debug?: boolean
  /** Runs when the text wants to change. `details.cancel()` stops it. */
  onValueChange?: (
    value: string,
    details: ChangeDetails<InputValueChangeReason>
  ) => void
  /** Its id, which a Field's label points at. */
  id?: string
  /** The Field around it, as its `field` yields. */
  field?: FieldContext
  /** Renders no element: bind your own with the yielded `part`. */
  render?: boolean
}

export { type TextControlArgs }
