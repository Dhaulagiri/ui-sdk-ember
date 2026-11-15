import Component from "@glimmer/component"
import { drawer } from "@ui-sdk/core/drawer"
import { usePart, type PartSignature } from "../use-part"

/** Describes the drawer while it's rendered. A paragraph by default. */
class DrawerDescription extends Component<
  PartSignature<typeof drawer, "description", HTMLParagraphElement>
> {
  part = usePart(this, () => this.args.handle, "description")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <p ...attributes {{this.part.modifier}}>{{yield this.part.yielded}}</p>
    {{/if}}
  </template>
}

export default DrawerDescription
