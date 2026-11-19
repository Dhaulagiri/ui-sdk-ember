import { hash } from "@ember/helper"
import type { WithBoundArgs } from "@glint/template"
import Component from "@glimmer/component"
import type { ChangeDetails } from "@ui-sdk/core"
import {
  segmentedControl,
  type SegmentedControlController,
  type SegmentedControlOrientation,
  type SegmentedControlValueChangeReason,
} from "@ui-sdk/core/segmented-control"
import { useFieldControl, type FieldContext } from "../field/context"
import { usePart, type RootYield } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import SegmentedControlIndicator from "./segmented-control-indicator.gts"
import SegmentedControlItem from "./segmented-control-item.gts"

/** A row of options where exactly one is on, like a radio group drawn as buttons, with an indicator that slides to the checked item. */
class SegmentedControl extends Component<{
  Element: HTMLDivElement
  Args: {
    /** The checked item's value. Pass it with `@onValueChange` to control the control. */
    value?: string | null
    /** The checked item's value at first, when uncontrolled. A form reset returns to it. */
    defaultValue?: string | null
    /** Disables every item. */
    disabled?: boolean
    /** Keeps it focusable and submitted, but presses don't change it. */
    readOnly?: boolean
    /** Blocks form submission until an item is checked. */
    required?: boolean
    /** The name the value submits under. */
    name?: string
    /** The id of a form to belong to, when it isn't inside that form. */
    form?: string
    /** Whether arrow keys wrap from the last item to the first. */
    loop?: boolean
    /** Which arrow keys move between items. */
    orientation?: SegmentedControlOrientation
    /** Drives the control from anywhere. Create one with `createSegmentedControlController()`. */
    controller?: SegmentedControlController
    /** Logs every state change with its reason. */
    debug?: boolean
    /** Runs when an item wants to change the value. `details.cancel()` stops it. */
    onValueChange?: (
      value: string | null,
      details: ChangeDetails<SegmentedControlValueChangeReason>
    ) => void
    /** Its id, which a Field's label points at. */
    id?: string
    /** The Field around it, as its `field` yields. */
    field?: FieldContext
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: {
    default: [
      RootYield<typeof segmentedControl> & {
        Item: WithBoundArgs<typeof SegmentedControlItem, "handle">
        Indicator: WithBoundArgs<typeof SegmentedControlIndicator, "handle">
      },
    ]
  }
}> {
  fieldControl = useFieldControl(this, () => ({ id: this.args.id }))
  handle = usePrimitive(this, segmentedControl, () => ({
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
        Item=(component SegmentedControlItem handle=this.handle)
        Indicator=(component SegmentedControlIndicator handle=this.handle)
      )
      as |s|
    }}
      {{#if @render}}
        {{yield s}}
      {{else}}
        <div
          id={{@id}}
          ...attributes
          {{this.root.modifier}}
          {{this.fieldControl.modifier}}
        >{{yield s}}</div>
      {{/if}}
    {{/let}}
  </template>
}

export default SegmentedControl
