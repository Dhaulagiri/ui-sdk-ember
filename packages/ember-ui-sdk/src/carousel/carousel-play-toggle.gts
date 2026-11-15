import Component from "@glimmer/component"
import { carousel } from "@ui-sdk/core/carousel"
import type { PrimitiveHandle } from "../use-primitive"
import CarouselControl from "./carousel-control.gts"

const plain = { playing: false, paused: false }

/** Starts and stops rotation. Label it from `playing` in its state, as the carousel pattern asks. Outside its carousel it connects through `@controller`. */
class CarouselPlayToggle extends Component<{
  Element: HTMLButtonElement
  Args: {
    /** The root's instance. The root's yielded parts pass it already. */
    handle?: PrimitiveHandle<typeof carousel>
    /** The carousel's controller, for a control outside it. */
    controller?: object
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: { default: [{ part?: object; state: object }] }
}> {
  plain = plain

  <template>
    <CarouselControl
      ...attributes
      @handle={{@handle}}
      @controller={{@controller}}
      @slot="play-toggle"
      @plain={{this.plain}}
      @render={{@render}}
      as |control|
    >{{yield control}}</CarouselControl>
  </template>
}

export default CarouselPlayToggle
