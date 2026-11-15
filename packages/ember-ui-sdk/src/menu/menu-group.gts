import Component from "@glimmer/component"
import { menu } from "@ui-sdk/core/menu"
import { usePart, type PartSignature } from "../use-part"
import MenuGroupLabel from "./menu-group-label.gts"

let count = 0

/** A group of items, named by its `Label`. */
class MenuGroup extends Component<
  PartSignature<typeof menu, "group", HTMLDivElement>
> {
  id = `ui-sdk-e-menu-group${++count}`
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
        Label=(component MenuGroupLabel handle=@handle group=this.id)
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

export default MenuGroup
