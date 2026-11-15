import Component from "@glimmer/component"
import { drawer } from "@ui-sdk/core/drawer"
import { controllerTarget } from "../controller-target"
import type { PartSignature } from "../use-part"
import type { PrimitiveHandle } from "../use-primitive"
import DrawerOutletBinding from "./drawer-outlet-binding.gts"

/** An element that follows the drawer, like the page behind it. Outside the drawer, pass its `@controller`. */
class DrawerOutlet extends Component<
  PartSignature<
    typeof drawer,
    "outlet",
    HTMLDivElement,
    { controller?: object; handle?: PrimitiveHandle<typeof drawer> }
  >
> {
  // A binding takes its drawer once, so another drawer gets a new one.
  get handles() {
    const handle = controllerTarget(this.args.controller, this.args.handle)
    return handle ? [handle] : []
  }

  get plain() {
    return { state: { open: false } } as never
  }

  <template>
    {{#each this.handles key="@identity" as |handle|}}
      <DrawerOutletBinding
        ...attributes
        @handle={{handle}}
        @keyframes={{@keyframes}}
        @render={{@render}}
        as |outlet|
      >{{yield outlet}}</DrawerOutletBinding>
    {{else}}
      {{#if @render}}
        {{yield this.plain}}
      {{else}}
        <div ...attributes>{{yield this.plain}}</div>
      {{/if}}
    {{/each}}
  </template>
}

export default DrawerOutlet
