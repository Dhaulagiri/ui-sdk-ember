import Component from "@glimmer/component"
import { carousel } from "@ui-sdk/core/carousel"
import { usePart, type PartSignature } from "../use-part"

// The bound part of an indicator, once its carousel is known.
class CarouselIndicatorBinding extends Component<
  PartSignature<typeof carousel, "indicator", HTMLButtonElement>
> {
  part = usePart(this, () => this.args.handle, "indicator")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <button ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</button>
    {{/if}}
  </template>
}

export default CarouselIndicatorBinding
