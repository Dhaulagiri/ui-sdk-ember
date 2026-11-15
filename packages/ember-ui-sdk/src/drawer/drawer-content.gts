import Component from "@glimmer/component"
import { drawer } from "@ui-sdk/core/drawer"
import { portalTarget } from "@ui-sdk/core/renderer"
import Portal from "../portal.gts"
import { usePart, type PartSignature } from "../use-part"

type Container = Element | DocumentFragment | null | undefined

/** The drawer itself, named by its title and described by its description. */
class DrawerContent extends Component<
  PartSignature<
    typeof drawer,
    "content",
    HTMLDivElement,
    { container?: Container; rootContainer?: Container }
  >
> {
  viewport = usePart(this, () => this.args.handle, "viewport")
  part = usePart(this, () => this.args.handle, "content")

  get target() {
    return portalTarget(this.args.container ?? this.args.rootContainer)
  }

  <template>
    {{#if this.part.present}}
      <Portal @to={{this.target}}>
        {{#if this.viewport.present}}
          <div {{this.viewport.modifier}}>
            {{#if @render}}
              {{yield this.part.yielded}}
            {{else}}
              <div ...attributes {{this.part.modifier}}>{{yield
                  this.part.yielded
                }}</div>
            {{/if}}
          </div>
        {{else if @render}}
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

export default DrawerContent
