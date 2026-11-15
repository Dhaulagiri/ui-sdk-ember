import Component from "@glimmer/component"
import { menu } from "@ui-sdk/core/menu"
import { usePart, type PartSignature } from "../use-part"

/** The item that opens its submenu. */
class MenuSubTrigger extends Component<
  PartSignature<typeof menu, "trigger", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "trigger")

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

export default MenuSubTrigger
