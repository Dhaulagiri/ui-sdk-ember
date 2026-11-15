import Component from "@glimmer/component"
import { navigationMenu } from "@ui-sdk/core/navigation-menu"
import { portalTarget } from "@ui-sdk/core/renderer"
import Portal from "../portal.gts"
import { usePart, type PartSignature } from "../use-part"

type Container = Element | DocumentFragment | null | undefined

/** Where the open item's content shows, one panel that resizes as the content changes. */
class NavigationMenuViewport extends Component<
  PartSignature<
    typeof navigationMenu,
    "viewport",
    HTMLDivElement,
    { container?: Container; rootContainer?: Container }
  >
> {
  part = usePart(this, () => this.args.handle, "viewport")

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

export default NavigationMenuViewport
