import Component from "@glimmer/component"
import { accordion } from "@ui-sdk/core/accordion"
import { usePart, type PartSignature } from "../use-part"

/** The button that opens and closes its item's panel. Put it inside the item's `Header`. */
class AccordionTrigger extends Component<
  PartSignature<typeof accordion, "trigger", HTMLButtonElement>
> {
  part = usePart(this, () => this.args.handle, "trigger")

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

export default AccordionTrigger
