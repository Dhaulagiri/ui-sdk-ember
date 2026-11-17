import { hash } from "@ember/helper"
import Component from "@glimmer/component"
import type { ChangeDetails, CommitDetails } from "@ui-sdk/core"
import { slider } from "@ui-sdk/core/slider"
import {
  useFieldControl,
  useFieldValues,
  type FieldContext,
} from "../field/context"
import { usePart } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import SliderControl from "./slider-control.gts"
import SliderIndicator from "./slider-indicator.gts"
import SliderThumb from "./slider-thumb.gts"
import SliderTrack from "./slider-track.gts"
import SliderValue from "./slider-value.gts"

/** The root: a group around the thumbs, and the hidden input the form submits. Yields its parts. */
class Slider extends Component<{
  Element: HTMLDivElement
  Args: {
    /** The value: a number for one thumb, or one number per thumb. Pass it with `@onValueChange` to control it. */
    value?: number | number[]
    /** The value at first, when uncontrolled. A form reset returns to it. */
    defaultValue?: number | number[]
    /** The lowest value. */
    min?: number
    /** The highest value. */
    max?: number
    /** How far one step moves, from `min`. */
    step?: number
    /** How far Page Up, Page Down and Shift with an arrow key move. */
    largeStep?: number
    /** How many steps apart neighbouring thumbs stay. */
    minStepsBetweenThumbs?: number
    /** The slider's axis. Vertical sliders grow upward. */
    orientation?: "horizontal" | "vertical"
    /** Disables it like a native control. */
    disabled?: boolean
    /** Keeps it focusable and submitted, but stops changes. */
    readOnly?: boolean
    /** Marks it required, with `data-required`. */
    required?: boolean
    /** The name it submits under. */
    name?: string
    /** The id of a form to belong to. */
    form?: string
    /** How values read: `Intl.NumberFormat` options, or a function of the value. */
    format?: unknown
    /** The locale values are formatted in. */
    locale?: string
    /** Moves the slider from anywhere. */
    controller?: object
    /** Logs every state change with its reason. */
    debug?: boolean
    /** Runs while the value changes. `details.cancel()` stops it. */
    onValueChange?: (
      value: number | number[],
      details: ChangeDetails<string>
    ) => void
    /** Runs once an interaction that changed the value ends. */
    onValueCommit?: (
      value: number | number[],
      details: CommitDetails<string>
    ) => void
    /** Its id, which a Field's label points at for a range. */
    id?: string
    /** The Field around it, as its `field` yields. */
    field?: FieldContext
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: { default: [Record<string, any>] }
}> {
  // A range is a group the field's label names. A single thumb's input is
  // the control itself. Decided once, from the shape the slider starts with.
  isRange = (() => {
    const shape = this.args.value ?? this.args.defaultValue
    return Array.isArray(shape) && shape.length > 1
  })()
  fieldValues = useFieldValues(this)
  handle = usePrimitive(this, slider, () => ({
    disabled: this.args.disabled || this.fieldValues.disabled,
    name: this.args.name ?? this.fieldValues.name,
    thumbInputId: this.fieldValues.controlId,
  }))
  root = usePart(this, () => this.handle, "root")
  input = usePart(this, () => this.handle, "input")
  fieldControl = this.isRange
    ? useFieldControl(this, () => ({ id: this.args.id ?? this.root.attrs.id }))
    : undefined

  get thumbField() {
    return this.isRange ? undefined : this.args.field
  }

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        Control=(component SliderControl handle=this.handle)
        Track=(component SliderTrack handle=this.handle)
        Indicator=(component SliderIndicator handle=this.handle)
        Thumb=(component SliderThumb handle=this.handle field=this.thumbField)
        Value=(component SliderValue handle=this.handle)
      )
      as |s|
    }}
      {{#if @render}}
        {{yield s}}
      {{else}}
        {{#if this.fieldControl}}
          <div
            ...attributes
            {{this.root.modifier}}
            {{this.fieldControl.modifier}}
          >{{yield s}}</div>
        {{else}}
          <div ...attributes {{this.root.modifier}}>{{yield s}}</div>
        {{/if}}
      {{/if}}
    {{/let}}
    <input {{this.input.modifier}} />
  </template>
}

export default Slider
