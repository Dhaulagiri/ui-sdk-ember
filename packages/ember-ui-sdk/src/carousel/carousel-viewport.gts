import Component from "@glimmer/component"
import { carousel } from "@ui-sdk/core/carousel"
import { usePart, type PartSignature } from "../use-part"

/** The scrolling window onto the slides. Touch, wheels and keys scroll it natively. */
class CarouselViewport extends Component<
  PartSignature<typeof carousel, "viewport", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "viewport")

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

export default CarouselViewport
