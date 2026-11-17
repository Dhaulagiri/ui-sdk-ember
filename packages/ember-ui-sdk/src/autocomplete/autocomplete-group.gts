import { hash } from "@ember/helper"
import Component from "@glimmer/component"
import { autocomplete } from "@ui-sdk/core/autocomplete"
import { usePart, type PartSignature } from "../use-part"
import AutocompleteGroupLabel from "./autocomplete-group-label.gts"
import AutocompleteItem from "./autocomplete-item.gts"
import AutocompleteItems from "./autocomplete-items.gts"

let count = 0

/** Items under a label. Yields its `Label`, `Item` and `Items`. */
class AutocompleteGroup extends Component<
  PartSignature<typeof autocomplete, "group", HTMLDivElement>
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
        Label=(component AutocompleteGroupLabel handle=@handle group=this.id)
        Item=(component AutocompleteItem handle=@handle group=this.id)
        Items=(component AutocompleteItems handle=@handle group=this.id)
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

export default AutocompleteGroup
