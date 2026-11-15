import Component from "@glimmer/component"
import { scrollArea } from "@ui-sdk/core/scroll-area"
import { usePart, type PartSignature } from "../use-part"

/** Wraps the content inside the viewport. */
class ScrollAreaContent extends Component<
  PartSignature<typeof scrollArea, "content", HTMLDivElement>
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

export default ScrollAreaContent
