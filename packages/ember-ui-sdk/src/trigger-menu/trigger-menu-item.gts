import Component from "@glimmer/component"
import { triggerMenu } from "@ui-sdk/core/trigger-menu"
import { usePart, type PartSignature } from "../use-part"
import TriggerMenuItemIcon from "./trigger-menu-item-icon.gts"

/** An item. Pressing it, or Enter while it's highlighted, selects it. Yields its `Icon`. */
class TriggerMenuItem extends Component<
  PartSignature<typeof triggerMenu, "item", HTMLDivElement, { group?: string }>
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
        Icon=(component TriggerMenuItemIcon handle=@handle item=this.key)
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

export default TriggerMenuItem
