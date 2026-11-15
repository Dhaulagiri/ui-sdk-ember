import Component from "@glimmer/component"
import { carousel } from "@ui-sdk/core/carousel"
import { usePart, type PartSignature } from "../use-part"

/** One slide. It's labelled "1 of 5" unless it has an `aria-label`, and inert while out of view. */
class CarouselItem extends Component<
  PartSignature<typeof carousel, "item", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "item")

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

export default CarouselItem
