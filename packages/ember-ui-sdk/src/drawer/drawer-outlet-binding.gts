import Component from "@glimmer/component"
import { drawer } from "@ui-sdk/core/drawer"
import { usePart, type PartSignature } from "../use-part"

// The bound part of an outlet, once its drawer is known.
class DrawerOutletBinding extends Component<
  PartSignature<typeof drawer, "outlet", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "outlet")

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

export default DrawerOutletBinding
