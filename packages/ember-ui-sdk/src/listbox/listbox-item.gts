import { hash } from "@ember/helper"
import Component from "@glimmer/component"
import { listbox } from "@ui-sdk/core/listbox"
import { usePart, type PartSignature } from "../use-part"
import ListboxItemIcon from "./listbox-item-icon.gts"
import ListboxItemIndicator from "./listbox-item-indicator.gts"

/** An option. Pressing it selects it, or toggles it with `multiple`. Yields its `Icon` and `Indicator`. */
class ListboxItem extends Component<
  PartSignature<typeof listbox, "item", HTMLDivElement, { group?: string }>
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
    return this.args.handle.api.internal.keyOf(this.args.value) as string
  }

  <template>
    {{#let
      (hash
        part=this.part.modifier
        state=this.part.state
        Icon=(component ListboxItemIcon handle=@handle item=this.key)
        Indicator=(component ListboxItemIndicator handle=@handle item=this.key)
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

export default ListboxItem
