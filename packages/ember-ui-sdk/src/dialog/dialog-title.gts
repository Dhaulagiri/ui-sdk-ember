import Component from "@glimmer/component"
import { dialog } from "@ui-sdk/core/dialog"
import { usePart, type PartSignature } from "../use-part"

/** The dialog's title, which names it. A level 2 heading by default. */
class DialogTitle extends Component<
  PartSignature<typeof dialog, "title", HTMLHeadingElement>
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

export default DialogTitle
