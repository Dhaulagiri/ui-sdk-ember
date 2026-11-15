import Component from "@glimmer/component"
import { portalTarget } from "@ui-sdk/core/renderer"
import { tooltip } from "@ui-sdk/core/tooltip"
import Portal from "../portal.gts"
import { usePart, type PartSignature } from "../use-part"

type Container = Element | DocumentFragment | null | undefined

/** The tooltip itself, positioned against its trigger. Always in the page, hidden while closed, so the trigger can point at it. */
class TooltipContent extends Component<
  PartSignature<
    typeof tooltip,
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
    <Portal @to={{this.target}}>
      {{#if @render}}
        {{yield this.part.yielded}}
      {{else}}
        <div ...attributes {{this.part.modifier}}>{{yield
            this.part.yielded
          }}</div>
      {{/if}}
    </Portal>
  </template>
}

export default TooltipContent
