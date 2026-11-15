import Component from "@glimmer/component"
import { drawer } from "@ui-sdk/core/drawer"
import { portalTarget } from "@ui-sdk/core/renderer"
import Portal from "../portal.gts"
import { usePart, type PartSignature } from "../use-part"

/** A dim behind the drawer. It's optional: without it, style the content's `::backdrop`. */
class DrawerBackdrop extends Component<
  PartSignature<
    typeof drawer,
    "backdrop",
    HTMLDivElement,
    { rootContainer?: Element | DocumentFragment | null }
  >
> {
  part = usePart(this, () => this.args.handle, "backdrop")

  // Rendered where the content renders, so it sits in the top layer just below it.
  get target() {
    return portalTarget(this.args.rootContainer)
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

export default DrawerBackdrop
