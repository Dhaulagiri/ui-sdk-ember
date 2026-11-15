import Component from "@glimmer/component"
import { autocomplete } from "@ui-sdk/core/autocomplete"
import { usePart, type PartSignature } from "../use-part"
import AutocompleteItemIcon from "./autocomplete-item-icon.gts"
import AutocompleteItemText from "./autocomplete-item-text.gts"

/** A suggestion. Choosing it fills the field in with its text. Yields its `Text` and `Icon`. */
class AutocompleteItem extends Component<
  PartSignature<typeof autocomplete, "item", HTMLDivElement, { group?: string }>
> {
  part = usePart(
    this,
    () => this.args.handle,
    "item",
    () => ({
      id: this.key,
      group: this.args.group,
    })
  )

  get key() {
    return this.args.value as string
  }

  get label() {
    const { label, value } = this.args
    return label ?? (value as string)
  }

  <template>
    {{#let
      (hash
        part=this.part.modifier
        state=this.part.state
        Text=(component
          AutocompleteItemText handle=@handle item=this.key label=this.label
        )
        Icon=(component AutocompleteItemIcon handle=@handle item=this.key)
      )
      as |item|
    }}
      {{#if @render}}
        {{yield item}}
      {{else}}
        <div ...attributes {{this.part.modifier}}>{{yield item}}</div>
      {{/if}}
    {{/let}}
  </template>
}

export default AutocompleteItem
