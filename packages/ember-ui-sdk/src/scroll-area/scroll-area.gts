import { hash } from "@ember/helper"
import type { WithBoundArgs } from "@glint/template"
import Component from "@glimmer/component"
import {
  scrollArea,
  type ScrollAreaController,
  type ScrollAreaType,
} from "@ui-sdk/core/scroll-area"
import { usePart, type RootYield } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import ScrollAreaViewport from "./scroll-area-viewport.gts"
import ScrollAreaContent from "./scroll-area-content.gts"
import ScrollAreaScrollbar from "./scroll-area-scrollbar.gts"
import ScrollAreaCorner from "./scroll-area-corner.gts"
import ScrollAreaScrollToEnd from "./scroll-area-scroll-to-end.gts"

/** Groups the parts. The scrollbars are placed against it. Yields its parts. */
class ScrollArea extends Component<{
  Element: HTMLDivElement
  Args: {
    /** When the scrollbars show. */
    type?: ScrollAreaType
    /** How long, in milliseconds, scrollbars stay after scrolling stops, for the types that hide them. */
    scrollHideDelay?: number
    /** Keeps the view at the end while content grows, until the reader scrolls away. */
    stickToEnd?: boolean
    /** Scrolls from anywhere. Create one with `createScrollAreaController()`. */
    controller?: ScrollAreaController
    /** Logs every state change with its reason. */
    debug?: boolean
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: {
    default: [
      RootYield<typeof scrollArea> & {
        Viewport: WithBoundArgs<typeof ScrollAreaViewport, "handle">
        Content: WithBoundArgs<typeof ScrollAreaContent, "handle">
        Scrollbar: WithBoundArgs<typeof ScrollAreaScrollbar, "handle">
        Corner: WithBoundArgs<typeof ScrollAreaCorner, "handle">
        ScrollToEnd: WithBoundArgs<typeof ScrollAreaScrollToEnd, "handle">
      },
    ]
  }
}> {
  handle = usePrimitive(this, scrollArea)
  root = usePart(this, () => this.handle, "root")

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        Viewport=(component ScrollAreaViewport handle=this.handle)
        Content=(component ScrollAreaContent handle=this.handle)
        Scrollbar=(component ScrollAreaScrollbar handle=this.handle)
        Corner=(component ScrollAreaCorner handle=this.handle)
        ScrollToEnd=(component ScrollAreaScrollToEnd handle=this.handle)
      )
      as |s|
    }}
      {{#if @render}}
        {{yield s}}
      {{else}}
        <div ...attributes {{this.root.modifier}}>{{yield s}}</div>
      {{/if}}
    {{/let}}
  </template>
}

export default ScrollArea
