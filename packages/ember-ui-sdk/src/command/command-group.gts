import { hash } from "@ember/helper"
import Component from "@glimmer/component"
import { command } from "@ui-sdk/core/command"
import { usePart, type PartSignature } from "../use-part"
import CommandGroupLabel from "./command-group-label.gts"
import CommandItem from "./command-item.gts"

let count = 0

/** A group of commands. It hides while none of its commands matches the search. */
class CommandGroup extends Component<
  PartSignature<
    typeof command,
    "group",
    HTMLDivElement,
    { inPage?: string | null; data?: boolean }
  >
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
        Label=(component CommandGroupLabel handle=@handle group=this.id)
        Item=(component
          CommandItem handle=@handle group=this.id inPage=@inPage data=@data
        )
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

export default CommandGroup
