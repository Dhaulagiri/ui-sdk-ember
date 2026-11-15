import Component from "@glimmer/component"
import { combobox } from "@ui-sdk/core/combobox"
import { comboboxChips } from "@ui-sdk/core/renderer"
import { usePart, type PartSignature } from "../use-part"

/** A button inside a chip that removes its value. Name it with `aria-label`. */
class ComboboxChipRemove extends Component<
  PartSignature<typeof combobox, "chip-remove", HTMLButtonElement>
> {
  feature = this.args.handle.instance.use(comboboxChips)
  part = usePart(
    this,
    () => this.args.handle,
    "chip-remove",
    () => ({
      id: this.args.handle.api.internal.keyOf(this.args.value) as string,
      value: this.args.value,
    })
  )

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

export default ComboboxChipRemove
