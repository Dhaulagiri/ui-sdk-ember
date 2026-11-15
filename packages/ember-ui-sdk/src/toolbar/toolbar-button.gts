import Component from "@glimmer/component"
import { toolbar } from "@ui-sdk/core/toolbar"
import { usePart, type PartSignature } from "../use-part"

/** A button in the toolbar. Arrow keys move between it and the toolbar's other items. */
class ToolbarButton extends Component<
  PartSignature<typeof toolbar, "button", HTMLButtonElement>
> {
  part = usePart(this, () => this.args.handle, "button")

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

export default ToolbarButton
