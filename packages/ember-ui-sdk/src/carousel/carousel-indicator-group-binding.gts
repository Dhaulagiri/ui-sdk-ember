import Component from "@glimmer/component"
import { carousel } from "@ui-sdk/core/carousel"
import { usePart, type PartSignature } from "../use-part"

// The bound indicator group, once its carousel is known.
class CarouselIndicatorGroupBinding extends Component<
  PartSignature<typeof carousel, "indicator-group", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "indicator-group")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <div ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</div>
    {{/if}}
  </template>
}

export default CarouselIndicatorGroupBinding
