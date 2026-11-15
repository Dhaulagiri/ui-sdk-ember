import Component from "@glimmer/component"
import { toolbar } from "@ui-sdk/core/toolbar"
import { usePart, type PartSignature } from "../use-part"

/** A text field. Arrows move its caret, and leave it only from the end they point at. */
class ToolbarInput extends Component<
  PartSignature<typeof toolbar, "input", HTMLInputElement>
> {
  part = usePart(this, () => this.args.handle, "input")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <input ...attributes {{this.part.modifier}} />
    {{/if}}
  </template>
}

export default ToolbarInput
