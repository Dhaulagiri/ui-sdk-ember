import { hash } from "@ember/helper"
import Component from "@glimmer/component"
import {
  colorPicker,
  type ColorFormat,
  type ColorGamut,
  type ColorPickerController,
  type ColorPickerSpace,
  type ColorPickerValueChangeDetails,
  type ColorPickerValueCommitDetails,
} from "@ui-sdk/core/color-picker"
import { useFieldControl, type FieldContext } from "../field/context"
import { usePart } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import ColorPickerArea from "./color-picker-area.gts"
import ColorPickerChannelInput from "./color-picker-channel-input.gts"
import ColorPickerEyeDropper from "./color-picker-eye-dropper.gts"
import ColorPickerInput from "./color-picker-input.gts"
import ColorPickerSlider from "./color-picker-slider.gts"
import ColorPickerSwatch from "./color-picker-swatch.gts"
import ColorPickerSwatchItem from "./color-picker-swatch-item.gts"
import ColorPickerSwatches from "./color-picker-swatches.gts"

/** The root: a group around the picker's parts, and the hidden input the form submits. Yields its parts. */
class ColorPicker extends Component<{
  Element: HTMLDivElement
  Args: {
    /** The value, as a CSS color. Pass it with `@onValueChange` to control it. */
    value?: string
    /** The value at first, when uncontrolled. A form reset returns to it. */
    defaultValue?: string
    /** The space the parts edit in, which decides their channels. */
    space?: ColorPickerSpace
    /** How the value is written: `"hex"`, or a space in its CSS syntax. */
    format?: ColorFormat
    /** The colors the value can hold: `"srgb"`, `"p3"`, or `false` for any. */
    gamut?: ColorGamut | false
    /** Disables every part: they can't be focused or changed, and the value isn't submitted. */
    disabled?: boolean
    /** Keeps the parts focusable and the value submitted, but stops changes. */
    readOnly?: boolean
    /** Marks it required, with `data-required`. */
    required?: boolean
    /** The name the value submits under. */
    name?: string
    /** The id of a form to belong to, when it isn't inside that form. */
    form?: string
    /** Sets the value from anywhere. Create one with `createColorPickerController()`. */
    controller?: ColorPickerController
    /** Logs every state change with its reason. */
    debug?: boolean
    /** Runs while the value changes. `details.cancel()` stops it. */
    onValueChange?: (
      value: string,
      details: ColorPickerValueChangeDetails
    ) => void
    /** Runs once an interaction that changed the value ends. For saving. */
    onValueCommit?: (
      value: string,
      details: ColorPickerValueCommitDetails
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
  handle = usePrimitive(this, colorPicker, () => ({
    disabled: this.args.disabled || this.fieldControl.disabled,
    name: this.args.name ?? this.fieldControl.name,
  }))
  root = usePart(this, () => this.handle, "root")
  hidden = usePart(this, () => this.handle, "hidden-input")

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        Area=(component ColorPickerArea handle=this.handle)
        Slider=(component ColorPickerSlider handle=this.handle)
        Input=(component ColorPickerInput handle=this.handle)
        ChannelInput=(component ColorPickerChannelInput handle=this.handle)
        Swatch=(component ColorPickerSwatch handle=this.handle)
        EyeDropper=(component ColorPickerEyeDropper handle=this.handle)
        Swatches=(component ColorPickerSwatches handle=this.handle)
        SwatchItem=(component ColorPickerSwatchItem handle=this.handle)
      )
      as |c|
    }}
      {{#if @render}}
        {{yield c}}
      {{else}}
        <div
          ...attributes
          {{this.root.modifier}}
          {{this.fieldControl.modifier}}
        >{{yield c}}</div>
      {{/if}}
    {{/let}}
    <input {{this.hidden.modifier}} />
  </template>
}

export default ColorPicker
