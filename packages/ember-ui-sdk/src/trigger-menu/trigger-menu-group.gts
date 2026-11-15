import Component from "@glimmer/component"
import { triggerMenu } from "@ui-sdk/core/trigger-menu"
import { usePart, type PartSignature } from "../use-part"
import TriggerMenuGroupLabel from "./trigger-menu-group-label.gts"
import TriggerMenuItem from "./trigger-menu-item.gts"
import TriggerMenuItems from "./trigger-menu-items.gts"

let count = 0

/** Items under a label. Yields its `Label`, `Item` and `Items`. */
class TriggerMenuGroup extends Component<
  PartSignature<typeof triggerMenu, "group", HTMLDivElement>
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
        Label=(component TriggerMenuGroupLabel handle=@handle group=this.id)
        Item=(component TriggerMenuItem handle=@handle group=this.id)
        Items=(component TriggerMenuItems handle=@handle group=this.id)
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

export default TriggerMenuGroup
