import Component from "@glimmer/component"
import type { ChangeDetails } from "@ui-sdk/core"
import type { calendar } from "@ui-sdk/core/calendar"
import { datePicker, type DatePickerValue } from "@ui-sdk/core/date-picker"
import { useFieldValues, type FieldContext } from "../field/context"
import { usePart } from "../use-part"
import {
  syncOptions,
  usePrimitive,
  type PrimitiveHandle,
} from "../use-primitive"
import CalendarDay from "../calendar/calendar-day.gts"
import CalendarGrid from "../calendar/calendar-grid.gts"
import CalendarHeading from "../calendar/calendar-heading.gts"
import CalendarMonthSelect from "../calendar/calendar-month-select.gts"
import CalendarNext from "../calendar/calendar-next.gts"
import CalendarPrevious from "../calendar/calendar-previous.gts"
import CalendarYearSelect from "../calendar/calendar-year-select.gts"
import DatePickerClear from "./date-picker-clear.gts"
import DatePickerContent from "./date-picker-content.gts"
import DatePickerHint from "./date-picker-hint.gts"
import DatePickerInput from "./date-picker-input.gts"
import DatePickerPreset from "./date-picker-preset.gts"
import DatePickerTrigger from "./date-picker-trigger.gts"

type Details = ChangeDetails<string>

/** The root, and the hidden inputs that submit ISO dates. Without a block it renders an input, or two in range mode, the trigger and the popup. Yields its parts and the Calendar parts. */
class DatePicker extends Component<{
  Element: HTMLDivElement
  Args: Record<string, unknown> & {
    /** `"single"` picks a date, `"range"` picks a start and an end. */
    mode?: "single" | "range"
    /** The selected value: an ISO date, `[start, end]` in range mode, or `null`. Pass it with `@onValueChange` to control the date picker. */
    value?: DatePickerValue
    /** The value at first, when uncontrolled. A form reset returns to it. */
    defaultValue?: DatePickerValue
    /** The first month the calendar shows, like `"2026-10"`. Pass it with `@onMonthChange` to control the calendar. */
    month?: string
    /** Whether the popup is open. Pass it with `@onOpenChange` to control the popup. */
    open?: boolean
    /** How many months the calendar shows. */
    months?: number
    /** The name the date submits under. */
    name?: string
    /** The name a range's start submits under. */
    startName?: string
    /** The name a range's end submits under. */
    endName?: string
    /** Renders the popup into this element instead of in place. */
    container?: Element | DocumentFragment | null
    /** The Field around it, as its `field` yields. */
    field?: FieldContext
    /** Runs when the value wants to change. `details.cancel()` stops it. */
    onValueChange?: (value: DatePickerValue, details: Details) => void
    /** Runs when the popup wants to open or close. `details.cancel()` stops it. */
    onOpenChange?: (open: boolean, details: Details) => void
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: { default: [Record<string, any>] }
}> {
  fieldValues = useFieldValues(this)
  handle = usePrimitive(this, datePicker, () => ({
    disabled: (this.args.disabled || this.fieldValues.disabled) as
      boolean | undefined,
    name: this.args.name ?? this.fieldValues.name,
  }))
  calendar = this.handle as unknown as PrimitiveHandle<typeof calendar>
  root = usePart(this, () => this.handle, "root")
  startInput = usePart(
    this,
    () => this.handle,
    "hidden-input",
    () => ({
      id: "start",
    })
  )
  endInput = usePart(
    this,
    () => this.handle,
    "hidden-input",
    () => ({
      end: true,
      id: "end",
    })
  )

  get range() {
    return (this.root.state as { mode?: string }).mode === "range"
  }

  get submitsStart() {
    const name = this.args.name ?? this.fieldValues.name
    return this.range ? (this.args.startName ?? name) : name
  }

  get submitsEnd() {
    return (
      this.range &&
      (this.args.endName ?? this.args.name ?? this.fieldValues.name)
    )
  }

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        Input=(component DatePickerInput handle=this.handle field=@field)
        Trigger=(component DatePickerTrigger handle=this.handle)
        Clear=(component DatePickerClear handle=this.handle)
        Hint=(component DatePickerHint handle=this.handle)
        Preset=(component DatePickerPreset handle=this.handle)
        Content=(component
          DatePickerContent
          handle=this.handle
          rootContainer=@container
          months=@months
        )
        Previous=(component CalendarPrevious handle=this.calendar)
        Next=(component CalendarNext handle=this.calendar)
        Heading=(component CalendarHeading handle=this.calendar)
        MonthSelect=(component CalendarMonthSelect handle=this.calendar)
        YearSelect=(component CalendarYearSelect handle=this.calendar)
        Grid=(component CalendarGrid handle=this.calendar)
        Day=(component CalendarDay handle=this.calendar)
      )
      as |d|
    }}
      {{#if @render}}
        {{yield d}}
      {{else}}
        <div ...attributes {{this.root.modifier}}>
          {{~#if (has-block)}}{{yield d}}{{else~}}
            <d.Input />
            {{~#if this.range}}<d.Input @end={{true}} />{{/if~}}
            <d.Trigger />
            <d.Content />
          {{~/if~}}
        </div>
      {{/if}}
    {{/let}}
    {{#if this.submitsStart}}<input {{this.startInput.modifier}} />{{/if}}
    {{#if this.submitsEnd}}<input {{this.endInput.modifier}} />{{/if}}
  </template>
}

export default DatePicker
