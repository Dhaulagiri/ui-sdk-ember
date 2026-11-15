import Component from "@glimmer/component"
import { scrollArea } from "@ui-sdk/core/scroll-area"
import { usePart, type PartSignature } from "../use-part"

/** The native scroller. Keyboard, wheels, touch, find in page and screen readers scroll it. */
class ScrollAreaViewport extends Component<
  PartSignature<typeof scrollArea, "viewport", HTMLDivElement>
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

export default ScrollAreaViewport
