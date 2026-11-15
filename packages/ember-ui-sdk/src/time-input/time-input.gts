import Component from "@glimmer/component"
import type { ChangeDetails } from "@ui-sdk/core"
import {
  timeInput,
  type TimeInputState,
  type TimeInputValueChangeReason,
} from "@ui-sdk/core/time-input"
import { useFieldControl, type FieldContext } from "../field/context"
import { usePart } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import TimeInputSegment from "./time-input-segment.gts"

/** The root: a group of segments, hours and minutes, with seconds and AM/PM when shown, and the hidden input the time submits with. Without a block it renders every segment; a block receives its state and can render `state.segments`. */
class TimeInput extends Component<{
  Element: HTMLDivElement
  Args: {
    /** The time, like `14:30`, or null while empty. Pass it with `@onValueChange` to control the input. */
    value?: string | null
    /** The value at first, when uncontrolled. A form reset returns to it. */
    defaultValue?: string | null
    /** The finest unit it shows. */
    granularity?: "hour" | "minute" | "second"
    /** Whether hours run to 12 or 24. */
    hourCycle?: 12 | 24
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
    /** Changes the value from anywhere. Create one with `createTimeInputController()`. */
    controller?: object
    /** Logs every state change with its reason. */
    debug?: boolean
    /** Runs while the value changes. `details.cancel()` stops it. */
    onValueChange?: (
      value: string | null,
      details: ChangeDetails<TimeInputValueChangeReason>
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
  handle = usePrimitive(this, timeInput, () => ({
    disabled: this.args.disabled || this.fieldControl.disabled,
    name: this.args.name ?? this.fieldControl.name,
  }))
  root = usePart(this, () => this.handle, "root")
  hidden = usePart(this, () => this.handle, "hidden-input")

  get segments() {
    return (this.root.state as TimeInputState).segments
  }

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        Segment=(component TimeInputSegment handle=this.handle)
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
              <TimeInputSegment @handle={{this.handle}} @segment={{segment}} />
            {{~/each~}}
          {{/if~}}
          <input {{this.hidden.modifier}} />
        </div>
      {{/if}}
    {{/let}}
  </template>
}

export default TimeInput
