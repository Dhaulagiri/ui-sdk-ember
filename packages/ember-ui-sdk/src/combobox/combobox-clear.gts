import Component from "@glimmer/component"
import { combobox } from "@ui-sdk/core/combobox"
import { usePart, type PartSignature } from "../use-part"

/** A button that empties the input and selects nothing. Shown while there's something to clear, or always with `keepMounted`. */
class ComboboxClear extends Component<
  PartSignature<typeof combobox, "clear", HTMLButtonElement>
> {
  part = usePart(this, () => this.args.handle, "clear")

  <template>
    {{#if this.part.present}}
      {{#if @render}}
        {{yield this.part.yielded}}
      {{else}}
        <button ...attributes {{this.part.modifier}}>{{yield
            this.part.yielded
          }}</button>
      {{/if}}
    {{/if}}
  </template>
}

export default ComboboxClear
