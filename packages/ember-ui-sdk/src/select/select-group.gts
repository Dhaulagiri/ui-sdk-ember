import { hash } from "@ember/helper"
import Component from "@glimmer/component"
import { select } from "@ui-sdk/core/select"
import { usePart, type PartSignature } from "../use-part"
import SelectGroupLabel from "./select-group-label.gts"
import SelectItem from "./select-item.gts"
import SelectItems from "./select-items.gts"
import SelectSelectAll from "./select-select-all.gts"

let count = 0

/** Items under a label. Yields its `Label`, `Item`, `Items` and `SelectAll`. */
class SelectGroup extends Component<
  PartSignature<typeof select, "group", HTMLDivElement>
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
        Label=(component SelectGroupLabel handle=@handle group=this.id)
        Item=(component SelectItem handle=@handle group=this.id)
        Items=(component SelectItems handle=@handle group=this.id)
        SelectAll=(component SelectSelectAll handle=@handle group=this.id)
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

export default SelectGroup
