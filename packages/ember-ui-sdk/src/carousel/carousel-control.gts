import Component from "@glimmer/component"
import { carousel } from "@ui-sdk/core/carousel"
import { controllerTarget } from "../controller-target"
import type { PrimitiveHandle } from "../use-primitive"
import CarouselControlBinding from "./carousel-control-binding.gts"

// A button that works inside its carousel, or outside it through `@controller`.
class CarouselControl extends Component<{
  Element: HTMLButtonElement
  Args: {
    handle?: PrimitiveHandle<typeof carousel>
    controller?: object
    slot: "previous" | "next" | "play-toggle"
    plain: object
    render?: boolean
  }
  Blocks: { default: [{ part?: object; state: object }] }
}> {
  get handle() {
    return controllerTarget(this.args.controller, this.args.handle)
  }

  get plain() {
    return { state: this.args.plain }
  }

  <template>
    {{#if this.handle}}
      <CarouselControlBinding
        ...attributes
        @handle={{this.handle}}
        @slot={{@slot}}
        @render={{@render}}
        as |control|
      >{{yield control}}</CarouselControlBinding>
    {{else if @render}}
      {{yield this.plain}}
    {{else}}
      {{! Until the carousel it names mounts, a control outside it is a plain button. }}
      <button type="button" ...attributes>{{yield this.plain}}</button>
    {{/if}}
  </template>
}

export default CarouselControl
