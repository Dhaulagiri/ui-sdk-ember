import Component from "@glimmer/component"
import type {
  dateInput,
  DateInputSegmentData,
  DateInputSegmentState,
} from "@ui-sdk/core/date-input"
import { usePart, type PartModifier } from "../use-part"
import type { PrimitiveHandle } from "../use-primitive"

/** A segment: an input you type in, or a span for the text between segments. */
class Segment extends Component<{
  Element: HTMLInputElement | HTMLSpanElement
  Args: {
    handle: PrimitiveHandle<typeof dateInput>
    segment: DateInputSegmentData
    render?: boolean
  }
  Blocks: { default: [{ part: PartModifier; state: DateInputSegmentState }] }
}> {
  editable = this.args.segment.editable
  part = usePart(
    this,
    () => this.args.handle,
    "segment",
    () => ({ segment: this.args.segment, id: this.args.segment.key })
  )

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else if this.editable}}
      <input ...attributes {{this.part.modifier}} />
    {{else}}
      <span ...attributes {{this.part.modifier}}>
        {{~#if (has-block)}}{{yield
            this.part.yielded
          }}{{else}}{{this.part.state.text}}{{/if~}}
      </span>
    {{/if}}
  </template>
}

export default Segment
