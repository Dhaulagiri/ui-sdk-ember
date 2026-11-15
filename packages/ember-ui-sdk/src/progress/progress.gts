import Component from "@glimmer/component"
import {
  progress,
  type GaugeLabelDetails,
  type NumberFormat,
} from "@ui-sdk/core/progress"
import { usePart } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import ProgressIndicator from "./progress-indicator.gts"
import ProgressLabel from "./progress-label.gts"
import ProgressTrack from "./progress-track.gts"
import ProgressValue from "./progress-value.gts"

/** The root. Yields its parts. */
class Progress extends Component<{
  Element: HTMLDivElement
  Args: {
    /** The current value, or null while it's unknown. */
    value?: number | null
    /** The smallest value. */
    min?: number
    /** The largest value. */
    max?: number
    /** How the value formats, as `Intl.NumberFormat` options. */
    format?: NumberFormat
    /** The locale the value formats in. */
    locale?: string
    /** Writes the value for screen readers. */
    getValueLabel?: (value: number | null, details: GaugeLabelDetails) => string
    /** Logs every state change with its reason. */
    debug?: boolean
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: { default: [Record<string, any>] }
}> {
  handle = usePrimitive(this, progress)
  root = usePart(this, () => this.handle, "root")

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        Track=(component ProgressTrack handle=this.handle)
        Indicator=(component ProgressIndicator handle=this.handle)
        Label=(component ProgressLabel handle=this.handle)
        Value=(component ProgressValue handle=this.handle)
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

export default Progress
