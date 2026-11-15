import Component from "@glimmer/component"
import type {
  timeInput,
  TimeInputSegmentData,
  TimeInputSegmentState,
} from "@ui-sdk/core/time-input"
import type { PartModifier } from "../use-part"
import type { PrimitiveHandle } from "../use-primitive"
import Segment from "../date-input/segment.gts"

/** A segment, like the hour: an input arrow keys step and digits fill, named by its unit. The text between segments renders as a span. */
class TimeInputSegment extends Component<{
  Element: HTMLInputElement | HTMLSpanElement
  Args: {
    handle: PrimitiveHandle<typeof timeInput>
    segment: TimeInputSegmentData
    render?: boolean
  }
  Blocks: { default: [{ part: PartModifier; state: TimeInputSegmentState }] }
}> {
  <template>
    {{#if (has-block)}}
      <Segment
        {{! @glint-expect-error a time input shares the date input's segments }}
        @handle={{@handle}}
        @segment={{@segment}}
        @render={{@render}}
        ...attributes
        as |s|
      >{{yield s}}</Segment>
    {{else}}
      <Segment
        {{! @glint-expect-error a time input shares the date input's segments }}
        @handle={{@handle}}
        @segment={{@segment}}
        @render={{@render}}
        ...attributes
      />
    {{/if}}
  </template>
}

export default TimeInputSegment
