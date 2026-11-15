import Component from "@glimmer/component"
import { drawer } from "@ui-sdk/core/drawer"
import { usePart, type PartSignature } from "../use-part"

/** A button that closes the drawer. An `action` runs first, and a Promise it returns keeps the drawer open until it settles. */
class DrawerClose extends Component<
  PartSignature<typeof drawer, "close", HTMLButtonElement>
> {
  part = usePart(this, () => this.args.handle, "close")

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

export default DrawerClose
