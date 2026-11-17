import { hash } from "@ember/helper"
import Component from "@glimmer/component"
import { timeline } from "@ui-sdk/core/timeline"
import { usePart } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import TimelineItem from "./timeline-item.gts"

/** A list of dated events, like an activity feed or an order's history, with one tab stop and arrow keys between events. `@feed` makes it a feed of articles that loads more as people scroll. Yields its `Item`. */
class Timeline extends Component<{
  Element: HTMLDivElement
  Args: {
    /** Whether events run down or across. */
    orientation?: "horizontal" | "vertical"
    /** Whether arrow keys wrap from the last event to the first. */
    loop?: boolean
    /** Makes it a feed of articles that loads more as people scroll. */
    feed?: boolean
    /** Whether a feed is loading more events. */
    busy?: boolean
    /** Focuses events from anywhere. Create one with `createTimelineController()`. */
    controller?: object
    /** Logs every state change with its reason. */
    debug?: boolean
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: { default: [Record<string, any>] }
}> {
  handle = usePrimitive(this, timeline)
  root = usePart(this, () => this.handle, "root")

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        Item=(component TimelineItem handle=this.handle)
      )
      as |t|
    }}
      {{#if @render}}
        {{yield t}}
      {{else}}
        <div ...attributes {{this.root.modifier}}>{{yield t}}</div>
      {{/if}}
    {{/let}}
  </template>
}

export default Timeline
