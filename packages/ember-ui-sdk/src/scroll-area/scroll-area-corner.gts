import Component from "@glimmer/component"
import { scrollArea } from "@ui-sdk/core/scroll-area"
import { usePart, type PartSignature } from "../use-part"

/** Where the two scrollbars meet. */
class ScrollAreaCorner extends Component<
  PartSignature<typeof scrollArea, "corner", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "corner")

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

export default ScrollAreaCorner
