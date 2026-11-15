import Component from "@glimmer/component"
import { carousel } from "@ui-sdk/core/carousel"
import type { PrimitiveHandle } from "../use-primitive"
import CarouselControl from "./carousel-control.gts"

const plain = { disabled: true }

/** Goes to the next page. `aria-disabled` on the last page without `@loop`, where it stays focusable. Outside its carousel it connects through `@controller`. */
class CarouselNext extends Component<{
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
      @slot="next"
      @plain={{this.plain}}
      @render={{@render}}
      as |control|
    >{{yield control}}</CarouselControl>
  </template>
}

export default CarouselNext
