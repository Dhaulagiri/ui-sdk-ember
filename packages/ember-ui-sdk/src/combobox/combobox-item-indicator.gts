import Component from "@glimmer/component"
import { combobox } from "@ui-sdk/core/combobox"
import { usePart, type PartSignature } from "../use-part"

/** The check inside a selected item. Rendered while it's selected, or always with `keepMounted`. */
class ComboboxItemIndicator extends Component<
  PartSignature<typeof combobox, "item-indicator", HTMLSpanElement>
> {
  part = usePart(
    this,
    () => this.args.handle,
    "item-indicator",
    () => ({
      id: this.args.item,
      item: this.args.item,
    })
  )

  <template>
    {{~#if this.part.present~}}
      {{~#if @render~}}
        {{yield this.part.yielded}}
      {{~else~}}
        <span ...attributes {{this.part.modifier}}>{{yield
            this.part.yielded
          }}</span>
      {{~/if~}}
    {{~/if~}}
  </template>
}

export default ComboboxItemIndicator
