import Component from "@glimmer/component"
import { toolbar } from "@ui-sdk/core/toolbar"
import { usePart, type PartSignature } from "../use-part"

/** A link in the toolbar. Arrow keys move between it and the toolbar's other items. */
class ToolbarLink extends Component<
  PartSignature<typeof toolbar, "link", HTMLAnchorElement>
> {
  part = usePart(this, () => this.args.handle, "link")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <a ...attributes {{this.part.modifier}}>{{yield this.part.yielded}}</a>
    {{/if}}
  </template>
}

export default ToolbarLink
