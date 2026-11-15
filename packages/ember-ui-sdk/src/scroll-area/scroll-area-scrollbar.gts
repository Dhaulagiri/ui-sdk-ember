import Component from "@glimmer/component"
import { scrollArea } from "@ui-sdk/core/scroll-area"
import { usePart, type PartSignature } from "../use-part"
import ScrollAreaThumb from "./scroll-area-thumb.gts"

/** A scrollbar for one axis, over the viewport's edge. Yields its `Thumb`. */
class ScrollAreaScrollbar extends Component<
  PartSignature<typeof scrollArea, "scrollbar", HTMLDivElement>
> {
  get orientation() {
    return this.args.orientation ?? "vertical"
  }

  part = usePart(
    this,
    () => this.args.handle,
    "scrollbar",
    () => ({
      id: this.orientation,
      orientation: this.orientation,
    })
  )

  <template>
    {{#let
      (hash
        part=this.part.modifier
        state=this.part.state
        Thumb=(component
          ScrollAreaThumb handle=@handle orientation=this.orientation
        )
      )
      as |b|
    }}
      {{#if @render}}
        {{yield b}}
      {{else}}
        <div ...attributes {{this.part.modifier}}>{{yield b}}</div>
      {{/if}}
    {{/let}}
  </template>
}

export default ScrollAreaScrollbar
