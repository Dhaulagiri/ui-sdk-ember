import Component from "@glimmer/component"
import { hoverCard } from "@ui-sdk/core/hover-card"
import { usePart, type PartSignature } from "../use-part"

/** An arrow on the card's edge that points at its trigger. */
class HoverCardArrow extends Component<
  PartSignature<typeof hoverCard, "arrow", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "arrow")

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

export default HoverCardArrow
