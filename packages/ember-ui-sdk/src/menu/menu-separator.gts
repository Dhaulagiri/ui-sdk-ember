import Component from "@glimmer/component"
import { menu } from "@ui-sdk/core/menu"
import { usePart, type PartSignature } from "../use-part"

/** A line between items or groups. */
class MenuSeparator extends Component<
  PartSignature<typeof menu, "separator", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "separator")

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

export default MenuSeparator
