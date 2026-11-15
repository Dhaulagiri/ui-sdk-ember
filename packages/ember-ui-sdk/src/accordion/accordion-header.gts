import Component from "@glimmer/component"
import { accordion } from "@ui-sdk/core/accordion"
import { usePart, type PartSignature } from "../use-part"

/** A heading around the trigger, so screen readers can move between items by heading. */
class AccordionHeader extends Component<
  PartSignature<typeof accordion, "header", HTMLHeadingElement>
> {
  part = usePart(this, () => this.args.handle, "header")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <h3 ...attributes {{this.part.modifier}}>{{yield this.part.yielded}}</h3>
    {{/if}}
  </template>
}

export default AccordionHeader
