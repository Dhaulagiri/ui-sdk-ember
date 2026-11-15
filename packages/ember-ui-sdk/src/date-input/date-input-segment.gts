import Component from "@glimmer/component"
import type {
  dateInput,
  DateInputSegmentData,
  DateInputSegmentState,
} from "@ui-sdk/core/date-input"
import type { PartModifier } from "../use-part"
import type { PrimitiveHandle } from "../use-primitive"
import Segment from "./segment.gts"

/** A segment, like the month: an input arrow keys step and digits fill, named by its unit. The text between segments renders as a span. */
class DateInputSegment extends Component<{
  Element: HTMLInputElement | HTMLSpanElement
  Args: {
    handle: PrimitiveHandle<typeof dateInput>
    segment: DateInputSegmentData
    render?: boolean
  }
  Blocks: { default: [{ part: PartModifier; state: DateInputSegmentState }] }
}> {
  <template>
    {{#if (has-block)}}
      <Segment
        @handle={{@handle}}
        @segment={{@segment}}
        @render={{@render}}
        ...attributes
        as |s|
      >{{yield s}}</Segment>
    {{else}}
      <Segment
        @handle={{@handle}}
        @segment={{@segment}}
        @render={{@render}}
        ...attributes
      />
    {{/if}}
  </template>
}

export default DateInputSegment
