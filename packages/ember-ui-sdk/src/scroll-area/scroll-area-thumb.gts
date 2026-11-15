import Component from "@glimmer/component"
import { scrollArea } from "@ui-sdk/core/scroll-area"
import { usePart, type PartSignature } from "../use-part"

/** The part of the scrollbar that shows where the view is, and drags. */
class ScrollAreaThumb extends Component<
  PartSignature<
    typeof scrollArea,
    "thumb",
    HTMLDivElement,
    { orientation?: "vertical" | "horizontal" }
  >
> {
  get orientation() {
    return this.args.orientation ?? "vertical"
  }

  part = usePart(
    this,
    () => this.args.handle,
    "thumb",
    () => ({ id: this.orientation, orientation: this.orientation })
  )

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

export default ScrollAreaThumb
