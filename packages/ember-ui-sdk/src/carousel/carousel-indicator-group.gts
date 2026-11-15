import Component from "@glimmer/component"
import { carousel } from "@ui-sdk/core/carousel"
import { controllerTarget } from "../controller-target"
import type { PrimitiveHandle } from "../use-primitive"
import CarouselIndicator from "./carousel-indicator.gts"
import CarouselIndicatorGroupBinding from "./carousel-indicator-group-binding.gts"

const plainState = { page: 1, pageCount: null }

/** The indicators, as a tablist with one tab stop. Yields its `Indicator`, and `pageCount` in its state. Outside its carousel it connects through `@controller`. */
class CarouselIndicatorGroup extends Component<{
  Element: HTMLDivElement
  Args: {
    /** The root's instance. The root's yielded parts pass it already. */
    handle?: PrimitiveHandle<typeof carousel>
    /** The carousel's controller, for a group outside it. */
    controller?: object
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: { default: [Record<string, any>] }
}> {
  plainState = plainState

  get handle() {
    return controllerTarget(this.args.controller, this.args.handle)
  }

  <template>
    {{#if this.handle}}
      <CarouselIndicatorGroupBinding
        ...attributes
        @handle={{this.handle}}
        @render={{@render}}
        as |group|
      >
        {{yield
          (hash
            part=group.part
            state=group.state
            Indicator=(component CarouselIndicator handle=this.handle)
          )
        }}
      </CarouselIndicatorGroupBinding>
    {{else}}
      {{#let
        (hash state=this.plainState Indicator=(component CarouselIndicator))
        as |group|
      }}
        {{#if @render}}
          {{yield group}}
        {{else}}
          <div ...attributes>{{yield group}}</div>
        {{/if}}
      {{/let}}
    {{/if}}
  </template>
}

export default CarouselIndicatorGroup
