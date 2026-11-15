import Component from "@glimmer/component"
import { carousel } from "@ui-sdk/core/carousel"
import { usePart, type PartSignature } from "../use-part"

/** The row, or column, of slides inside the viewport. */
class CarouselContent extends Component<
  PartSignature<typeof carousel, "content", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "content")

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

export default CarouselContent
