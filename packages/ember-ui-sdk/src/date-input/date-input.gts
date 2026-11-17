import { hash } from "@ember/helper"
import Component from "@glimmer/component"
import type { ChangeDetails } from "@ui-sdk/core"
import {
  dateInput,
  type DateInputState,
  type DateInputValueChangeReason,
} from "@ui-sdk/core/date-input"
import { useFieldControl, type FieldContext } from "../field/context"
import { usePart } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import DateInputSegment from "./date-input-segment.gts"

/** The root: a group of segments the locale orders, like month, day and year, and the hidden input the ISO value submits with. Without a block it renders every segment; a block receives its state and can render `state.segments`. */
class DateInput extends Component<{
  Element: HTMLDivElement
  Args: {
    /** The ISO date, or date and time, or null while empty. Pass it with `@onValueChange` to control the input. */
    value?: string | null
    /** The value at first, when uncontrolled. A form reset returns to it. */
    defaultValue?: string | null
    /** The finest unit it shows. */
    granularity?: "day" | "hour" | "minute" | "second"
    /** Whether hours run to 12 or 24. */
    hourCycle?: 12 | 24
    /** The earliest date. */
    min?: string
    /** The latest date. */
    max?: string
    /** Dates that can't be picked. */
    unavailable?: object
    /** The locale the segments are ordered and formatted in. */
    locale?: string
    /** Disables it. */
    disabled?: boolean
    /** Keeps it focusable and submitted, but stops changes. */
    readOnly?: boolean
    /** Marks it required. */
    required?: boolean
    /** The name it submits under. */
    name?: string
    /** The id of a form to belong to. */
    form?: string
    /** Changes the value from anywhere. Create one with `createDateInputController()`. */
    controller?: object
    /** Logs every state change with its reason. */
    debug?: boolean
    /** Runs while the value changes. `details.cancel()` stops it. */
    onValueChange?: (
      value: string | null,
      details: ChangeDetails<DateInputValueChangeReason>
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
  handle = usePrimitive(this, dateInput, () => ({
    disabled: this.args.disabled || this.fieldControl.disabled,
    name: this.args.name ?? this.fieldControl.name,
  }))
  root = usePart(this, () => this.handle, "root")
  hidden = usePart(this, () => this.handle, "hidden-input")

  get segments() {
    return (this.root.state as DateInputState).segments
  }

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        Segment=(component DateInputSegment handle=this.handle)
      )
      as |d|
    }}
      {{#if @render}}
        {{yield d}}
        <input {{this.hidden.modifier}} />
      {{else}}
        <div
          ...attributes
          {{this.root.modifier}}
          {{this.fieldControl.modifier}}
        >
          {{~#if (has-block)}}{{yield d}}{{else}}
            {{~#each this.segments key="key" as |segment|~}}
              <DateInputSegment @handle={{this.handle}} @segment={{segment}} />
            {{~/each~}}
          {{/if~}}
          <input {{this.hidden.modifier}} />
        </div>
      {{/if}}
    {{/let}}
  </template>
}

export default DateInput
