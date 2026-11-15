import Component from "@glimmer/component"
import { dialog } from "@ui-sdk/core/dialog"
import { usePart, type PartSignature } from "../use-part"

/** Describes the dialog while it's rendered. A paragraph by default. */
class DialogDescription extends Component<
  PartSignature<typeof dialog, "description", HTMLParagraphElement>
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

export default DialogDescription
