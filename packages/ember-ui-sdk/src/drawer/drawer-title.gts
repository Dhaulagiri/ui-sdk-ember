import Component from "@glimmer/component"
import { drawer } from "@ui-sdk/core/drawer"
import { usePart, type PartSignature } from "../use-part"

/** The drawer's title, which names it. A level 2 heading by default. */
class DrawerTitle extends Component<
  PartSignature<typeof drawer, "title", HTMLHeadingElement>
> {
  part = usePart(this, () => this.args.handle, "title")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <h2 ...attributes {{this.part.modifier}}>{{yield this.part.yielded}}</h2>
    {{/if}}
  </template>
}

export default DrawerTitle
