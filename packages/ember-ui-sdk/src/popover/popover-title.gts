import Component from "@glimmer/component"
import { popover } from "@ui-sdk/core/popover"
import { usePart, type PartSignature } from "../use-part"

/** The popover's title, which names it. A level 2 heading by default. */
class PopoverTitle extends Component<
  PartSignature<typeof popover, "title", HTMLHeadingElement>
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

export default PopoverTitle
