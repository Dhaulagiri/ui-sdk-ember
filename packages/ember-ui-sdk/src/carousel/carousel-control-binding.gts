import Component from "@glimmer/component"
import { carousel } from "@ui-sdk/core/carousel"
import { usePart, type PartModifier } from "../use-part"
import type { PrimitiveHandle } from "../use-primitive"

type Slot = "previous" | "next" | "play-toggle"

// The bound button of a control that also works outside its carousel, once the carousel is known.
class CarouselControlBinding extends Component<{
  Element: HTMLButtonElement
  Args: {
    handle: PrimitiveHandle<typeof carousel>
    slot: Slot
    render?: boolean
  }
  Blocks: { default: [{ part: PartModifier; state: object }] }
}> {
  part = usePart(this, () => this.args.handle, this.args.slot)

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

export default CarouselControlBinding
