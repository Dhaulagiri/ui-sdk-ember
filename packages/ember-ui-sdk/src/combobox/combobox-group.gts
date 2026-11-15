import Component from "@glimmer/component"
import { combobox } from "@ui-sdk/core/combobox"
import { usePart, type PartSignature } from "../use-part"
import ComboboxGroupLabel from "./combobox-group-label.gts"
import ComboboxItem from "./combobox-item.gts"
import ComboboxItems from "./combobox-items.gts"
import ComboboxSelectAll from "./combobox-select-all.gts"

let count = 0

/** Items under a label. Yields its `Label`, `Item`, `Items` and `SelectAll`. */
class ComboboxGroup extends Component<
  PartSignature<typeof combobox, "group", HTMLDivElement>
> {
  id = `ui-sdk-e-group${++count}`
  part = usePart(
    this,
    () => this.args.handle,
    "group",
    () => ({ id: this.id })
  )

  <template>
    {{#let
      (hash
        part=this.part.modifier
        state=this.part.state
        Label=(component ComboboxGroupLabel handle=@handle group=this.id)
        Item=(component ComboboxItem handle=@handle group=this.id)
        Items=(component ComboboxItems handle=@handle group=this.id)
        SelectAll=(component ComboboxSelectAll handle=@handle group=this.id)
      )
      as |group|
    }}
      {{#if @render}}
        {{yield group}}
      {{else}}
        <div ...attributes {{this.part.modifier}}>{{yield group}}</div>
      {{/if}}
    {{/let}}
  </template>
}

export default ComboboxGroup
