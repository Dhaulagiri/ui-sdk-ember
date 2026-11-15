import Component from "@glimmer/component"
import { scrollArea } from "@ui-sdk/core/scroll-area"
import { usePart, type PartSignature } from "../use-part"

/** A button that scrolls to the end, like "Jump to latest". Name it with its content. */
class ScrollAreaScrollToEnd extends Component<
  PartSignature<typeof scrollArea, "scroll-to-end", HTMLButtonElement>
> {
  part = usePart(this, () => this.args.handle, "scroll-to-end")

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

export default ScrollAreaScrollToEnd
