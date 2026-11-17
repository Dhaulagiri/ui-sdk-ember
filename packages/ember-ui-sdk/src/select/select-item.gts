import { hash } from "@ember/helper"
import Component from "@glimmer/component"
import { select } from "@ui-sdk/core/select"
import { usePart, type PartSignature } from "../use-part"
import SelectItemIcon from "./select-item-icon.gts"
import SelectItemIndicator from "./select-item-indicator.gts"
import SelectItemText from "./select-item-text.gts"

/** An option in the list. Yields its `Text`, `Indicator` and `Icon`. */
class SelectItem extends Component<
  PartSignature<typeof select, "item", HTMLDivElement, { group?: string }>
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

  get label() {
    const { label, value } = this.args
    return label ?? (typeof value === "string" ? value : undefined)
  }

  <template>
    {{#let
      (hash
        part=this.part.modifier
        state=this.part.state
        Text=(component
          SelectItemText handle=@handle item=this.key label=this.label
        )
        Indicator=(component SelectItemIndicator handle=@handle item=this.key)
        Icon=(component SelectItemIcon handle=@handle item=this.key)
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

export default SelectItem
