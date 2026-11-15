import Component from "@glimmer/component"
import { accordion } from "@ui-sdk/core/accordion"
import { usePart, type PartSignature } from "../use-part"

/** The content its item's trigger shows and hides. */
class AccordionPanel extends Component<
  PartSignature<typeof accordion, "panel", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "panel")

  <template>
    {{#if this.part.present}}
      {{#if @render}}
        {{yield this.part.yielded}}
      {{else}}
        <div ...attributes {{this.part.modifier}}>{{yield
            this.part.yielded
          }}</div>
      {{/if}}
    {{/if}}
  </template>
}

export default AccordionPanel
