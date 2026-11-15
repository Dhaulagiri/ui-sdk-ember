import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import type { ChangeDetails } from "@ui-sdk/core"
import { carousel } from "@ui-sdk/core/carousel"
import { registerController } from "../controller-target"
import { usePart } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import CarouselContent from "./carousel-content.gts"
import CarouselIndicatorGroup from "./carousel-indicator-group.gts"
import CarouselItem from "./carousel-item.gts"
import CarouselNext from "./carousel-next.gts"
import CarouselPlayToggle from "./carousel-play-toggle.gts"
import CarouselPrevious from "./carousel-previous.gts"
import CarouselViewport from "./carousel-viewport.gts"

/** A region of slides that scroll a page at a time. Name it with `aria-label`. Yields its parts. */
class Carousel extends Component<{
  Element: HTMLDivElement
  Args: {
    /** The current page, from 1. Pass it with `@onPageChange` to control the carousel. */
    page?: number
    /** The page it starts on, from 1, when uncontrolled. */
    defaultPage?: number
    /** Whether it rotates through the pages on its own. Pass it with `@onPlayingChange` to control rotation. */
    playing?: boolean
    /** Whether it starts rotating, when uncontrolled. */
    defaultPlaying?: boolean
    /** How long each page shows while rotating, in ms. */
    interval?: number
    /** Which way the slides scroll, and which arrow keys page. */
    orientation?: "horizontal" | "vertical"
    /** Where a page lines up in the viewport. */
    align?: "start" | "center" | "end"
    /** How many slides one page holds. `"auto"` fits as many as the viewport shows. */
    slidesPerPage?: number | "auto"
    /** Whether the slides go round. */
    loop?: boolean
    /** Whether a fast swipe can pass over pages. */
    skipSnaps?: boolean
    /** Whether swipes and drags coast to wherever they stop instead of a page. */
    dragFree?: boolean
    /** Whether swiping, dragging and scrolling move the slides. */
    drag?: boolean
    /** Pages the carousel from anywhere, and connects parts outside it. */
    controller?: object
    /** Logs every state change with its reason. */
    debug?: boolean
    /** Runs when the page wants to change. `details.cancel()` stays on the page. */
    onPageChange?: (page: number, details: ChangeDetails<string>) => void
    /** Runs once the slides come to rest on a page. */
    onPageChangeComplete?: (page: number) => void
    /** Runs when rotation wants to start or stop. */
    onPlayingChange?: (playing: boolean, details: ChangeDetails<string>) => void
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: { default: [Record<string, any>] }
}> {
  handle = usePrimitive(this, carousel)
  root = usePart(this, () => this.handle, "root")

  constructor(owner: Owner, args: Carousel["args"]) {
    super(owner, args)
    registerController(this, () => this.args.controller, this.handle)
  }

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        Viewport=(component CarouselViewport handle=this.handle)
        Content=(component CarouselContent handle=this.handle)
        Item=(component CarouselItem handle=this.handle)
        Previous=(component CarouselPrevious handle=this.handle)
        Next=(component CarouselNext handle=this.handle)
        PlayToggle=(component CarouselPlayToggle handle=this.handle)
        IndicatorGroup=(component CarouselIndicatorGroup handle=this.handle)
      )
      as |c|
    }}
      {{#if @render}}
        {{yield c}}
      {{else}}
        <div ...attributes {{this.root.modifier}}>{{yield c}}</div>
      {{/if}}
    {{/let}}
  </template>
}

export default Carousel
