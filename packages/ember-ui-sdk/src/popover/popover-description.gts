import Component from "@glimmer/component"
import { popover } from "@ui-sdk/core/popover"
import { usePart, type PartSignature } from "../use-part"

/** The popover's description. */
class PopoverDescription extends Component<
  PartSignature<typeof popover, "description", HTMLParagraphElement>
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

export default PopoverDescription
