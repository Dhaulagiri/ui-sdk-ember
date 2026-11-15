import Component from "@glimmer/component"
import { drawer } from "@ui-sdk/core/drawer"
import { usePart, type PartSignature } from "../use-part"

/** The grabber. Pressing it moves to the next snap point; arrow keys, Home and End step. */
class DrawerHandle extends Component<
  PartSignature<typeof drawer, "handle", HTMLButtonElement>
> {
  part = usePart(this, () => this.args.handle, "handle")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <button ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</button>
    {{/if}}
  </template>
}

export default DrawerHandle
