import Component from "@glimmer/component"
import { combobox } from "@ui-sdk/core/combobox"
import { usePart, type PartSignature } from "../use-part"

/** An arrow on the popup's edge that points at the input. */
class ComboboxArrow extends Component<
  PartSignature<typeof combobox, "arrow", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "arrow")

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

export default ComboboxArrow
