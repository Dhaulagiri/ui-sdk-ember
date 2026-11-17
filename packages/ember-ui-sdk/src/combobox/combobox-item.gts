import { hash } from "@ember/helper"
import Component from "@glimmer/component"
import type { WithBoundArgs } from "@glint/template"
import { combobox } from "@ui-sdk/core/combobox"
import { usePart, type PartSignature } from "../use-part"
import ComboboxItemIcon from "./combobox-item-icon.gts"
import ComboboxItemIndicator from "./combobox-item-indicator.gts"
import ComboboxItemText from "./combobox-item-text.gts"

/** An option. Pressing it selects it, or toggles it with `multiple`. Yields its `Text`, `Indicator` and `Icon`. */
class ComboboxItem extends Component<
  PartSignature<
    typeof combobox,
    "item",
    HTMLDivElement,
    { group?: string },
    {
      Text: WithBoundArgs<typeof ComboboxItemText, "handle" | "item" | "label">
      Indicator: WithBoundArgs<typeof ComboboxItemIndicator, "handle" | "item">
      Icon: WithBoundArgs<typeof ComboboxItemIcon, "handle" | "item">
    }
  >
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
          ComboboxItemText handle=@handle item=this.key label=this.label
        )
        Indicator=(component ComboboxItemIndicator handle=@handle item=this.key)
        Icon=(component ComboboxItemIcon handle=@handle item=this.key)
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

export default ComboboxItem
