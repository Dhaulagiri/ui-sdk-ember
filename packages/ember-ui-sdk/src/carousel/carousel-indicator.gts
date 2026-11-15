import Component from "@glimmer/component"
import { carousel } from "@ui-sdk/core/carousel"
import type { PrimitiveHandle } from "../use-primitive"
import CarouselIndicatorBinding from "./carousel-indicator-binding.gts"

/** Shows a page and goes to it. Indicators past the page count hide themselves. */
class CarouselIndicator extends Component<{
  Element: HTMLButtonElement
  Args: {
    /** The root's instance, which its group passes. */
    handle?: PrimitiveHandle<typeof carousel>
    /** The page it shows, from 1. Without one, its place among the indicators. */
    page?: number
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: { default: [{ part?: object; state: object }] }
}> {
  get plain() {
    return { state: { page: this.args.page ?? 0, selected: false } }
  }

  <template>
    {{#if @handle}}
      <CarouselIndicatorBinding
        ...attributes
        @handle={{@handle}}
        @page={{@page}}
        @render={{@render}}
        as |indicator|
      >{{yield indicator}}</CarouselIndicatorBinding>
    {{else if @render}}
      {{yield this.plain}}
    {{else}}
      {{! In a group outside its carousel, before that mounts, it's a plain button. }}
      <button type="button" ...attributes>{{yield this.plain}}</button>
    {{/if}}
  </template>
}

export default CarouselIndicator
