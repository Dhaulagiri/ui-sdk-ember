import Component from "@glimmer/component"
import { hoverCard } from "@ui-sdk/core/hover-card"
import { portalTarget } from "@ui-sdk/core/renderer"
import Portal from "../portal.gts"
import { usePart, type PartSignature } from "../use-part"

type Container = Element | DocumentFragment | null | undefined

/** The card itself, positioned against its trigger. */
class HoverCardContent extends Component<
  PartSignature<
    typeof hoverCard,
    "content",
    HTMLDivElement,
    { container?: Container; rootContainer?: Container }
  >
> {
  part = usePart(this, () => this.args.handle, "content")

  get target() {
    return portalTarget(this.args.container ?? this.args.rootContainer)
  }

  <template>
    {{#if this.part.present}}
      <Portal @to={{this.target}}>
        {{#if @render}}
          {{yield this.part.yielded}}
        {{else}}
          <div ...attributes {{this.part.modifier}}>{{yield
              this.part.yielded
            }}</div>
        {{/if}}
      </Portal>
    {{/if}}
  </template>
}

export default HoverCardContent
