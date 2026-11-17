import { hash } from "@ember/helper"
import Component from "@glimmer/component"
import { timeline } from "@ui-sdk/core/timeline"
import { usePart, type PartSignature } from "../use-part"
import TimelineConnector from "./timeline-connector.gts"
import TimelineDescription from "./timeline-description.gts"
import TimelineMarker from "./timeline-marker.gts"
import TimelineTime from "./timeline-time.gts"
import TimelineTitle from "./timeline-title.gts"

let count = 0

/** One event. Arrow keys move between events, and links and buttons inside stay in the tab order. Yields its parts. */
class TimelineItem extends Component<
  PartSignature<typeof timeline, "item", HTMLDivElement>
> {
  generated = `ui-sdk-e-event${++count}`
  part = usePart(
    this,
    () => this.args.handle,
    "item",
    () => ({
      value: this.value,
    })
  )

  get value() {
    return this.args.value ?? this.generated
  }

  <template>
    {{#let
      (hash
        part=this.part.modifier
        state=this.part.state
        Marker=(component
          TimelineMarker handle=@handle value=this.value status=@status
        )
        Connector=(component
          TimelineConnector handle=@handle value=this.value status=@status
        )
        Title=(component
          TimelineTitle handle=@handle value=this.value status=@status
        )
        Time=(component
          TimelineTime handle=@handle value=this.value status=@status
        )
        Description=(component
          TimelineDescription handle=@handle value=this.value status=@status
        )
      )
      as |item|
    }}
      {{#if @render}}
        {{yield item}}
      {{else}}
        <div ...attributes {{this.part.modifier}}>{{yield item}}</div>
      {{/if}}
    {{/let}}
  </template>
}

export default TimelineItem
