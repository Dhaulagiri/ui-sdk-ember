import Component from "@glimmer/component"
import { combobox } from "@ui-sdk/core/combobox"
import { usePart, type PartSignature } from "../use-part"

/** A polite live region for loading and result counts. Its content is yours, from its children's state. */
class ComboboxStatus extends Component<
  PartSignature<typeof combobox, "status", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "status")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <div ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</div>
    {{/if}}
  </template>
}

export default ComboboxStatus
