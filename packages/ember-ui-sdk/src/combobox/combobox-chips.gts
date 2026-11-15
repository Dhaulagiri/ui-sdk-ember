import Component from "@glimmer/component"
import { combobox } from "@ui-sdk/core/combobox"
import { comboboxChips } from "@ui-sdk/core/renderer"
import { usePart, type PartSignature } from "../use-part"

/** The selected values as chips, around the input. */
class ComboboxChips extends Component<
  PartSignature<typeof combobox, "chips", HTMLDivElement>
> {
  feature = this.args.handle.instance.use(comboboxChips)
  part = usePart(this, () => this.args.handle, "chips")

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

export default ComboboxChips
