import { hash } from "@ember/helper"
import type { WithBoundArgs } from "@glint/template"
import Component from "@glimmer/component"
import {
  meter,
  type MeterLabelDetails,
  type NumberFormat,
} from "@ui-sdk/core/meter"
import { usePart, type RootYield } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import MeterIndicator from "./meter-indicator.gts"
import MeterLabel from "./meter-label.gts"
import MeterTrack from "./meter-track.gts"
import MeterValue from "./meter-value.gts"

/** The root. Yields its parts. */
class Meter extends Component<{
  Element: HTMLDivElement
  Args: {
    /** The current value. */
    value: number
    /** The smallest value. */
    min?: number
    /** The largest value. */
    max?: number
    /** How the value formats, as `Intl.NumberFormat` options. */
    format?: NumberFormat
    /** The locale the value formats in. */
    locale?: string
    /** Writes the value for screen readers. */
    getValueLabel?: (value: number, details: MeterLabelDetails) => string
    /** Logs every state change with its reason. */
    debug?: boolean
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: {
    default: [
      RootYield<typeof meter> & {
        Track: WithBoundArgs<typeof MeterTrack, "handle">
        Indicator: WithBoundArgs<typeof MeterIndicator, "handle">
        Label: WithBoundArgs<typeof MeterLabel, "handle">
        Value: WithBoundArgs<typeof MeterValue, "handle">
      },
    ]
  }
}> {
  handle = usePrimitive(this, meter)
  root = usePart(this, () => this.handle, "root")

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        Track=(component MeterTrack handle=this.handle)
        Indicator=(component MeterIndicator handle=this.handle)
        Label=(component MeterLabel handle=this.handle)
        Value=(component MeterValue handle=this.handle)
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

export default Meter
