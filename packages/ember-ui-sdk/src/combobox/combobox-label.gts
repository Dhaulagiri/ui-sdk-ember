import Component from "@glimmer/component"
import { combobox } from "@ui-sdk/core/combobox"
import { usePart, type PartSignature } from "../use-part"

/** A visible label for the input. */
class ComboboxLabel extends Component<
  PartSignature<typeof combobox, "label", HTMLLabelElement>
> {
  part = usePart(this, () => this.args.handle, "label")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <label ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</label>
    {{/if}}
  </template>
}

export default ComboboxLabel
