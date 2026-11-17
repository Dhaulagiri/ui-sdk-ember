import { hash } from "@ember/helper"
import Component from "@glimmer/component"
import { listbox } from "@ui-sdk/core/listbox"
import { usePart, type PartSignature } from "../use-part"
import ListboxGroupLabel from "./listbox-group-label.gts"
import ListboxItem from "./listbox-item.gts"
import ListboxItems from "./listbox-items.gts"

let count = 0

/** A group of items, named by its `Label`. Yields its `Label`, `Item` and `Items`. */
class ListboxGroup extends Component<
  PartSignature<typeof listbox, "group", HTMLDivElement>
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
        Label=(component ListboxGroupLabel handle=@handle group=this.id)
        Item=(component ListboxItem handle=@handle group=this.id)
        Items=(component ListboxItems handle=@handle group=this.id)
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

export default ListboxGroup
