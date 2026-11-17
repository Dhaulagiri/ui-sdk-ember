import { hash } from "@ember/helper"
import Component from "@glimmer/component"
import { command } from "@ui-sdk/core/command"
import { usePart, type PartSignature } from "../use-part"
import CommandItemIcon from "./command-item-icon.gts"
import CommandItemText from "./command-item-text.gts"
import CommandShortcut from "./command-shortcut.gts"

let count = 0

/** A command. Pressing it, or Enter while it's highlighted, runs it, with its `value` passed to the command's `onAction`. Yields its `Text`, `Shortcut` and `Icon`. */
class CommandItem extends Component<
  PartSignature<
    typeof command,
    "item",
    HTMLDivElement,
    { group?: string; inPage?: string | null; data?: boolean }
  >
> {
  generated = `ui-sdk-e-command${++count}`

  get key() {
    return (this.args.value as string | undefined) ?? this.generated
  }

  get label() {
    return (
      (this.args.label as string | undefined) ??
      (this.args.value as string | undefined)
    )
  }

  part = usePart(
    this,
    () => this.args.handle,
    "item",
    () => ({
      id: this.key,
      value: this.key,
      group: this.args.group,
      inPage: this.args.inPage,
      data: this.args.data ?? false,
    })
  )

  <template>
    {{#if this.part.present}}
      {{#let
        (hash
          part=this.part.modifier
          state=this.part.state
          Text=(component
            CommandItemText handle=@handle item=this.key label=this.label
          )
          Shortcut=(component
            CommandShortcut handle=@handle inherited=@shortcut
          )
          Icon=(component CommandItemIcon handle=@handle item=this.key)
        )
        as |item|
      }}
        {{#if @render}}
          {{yield item}}
        {{else}}
          <div ...attributes {{this.part.modifier}}>{{yield item}}</div>
        {{/if}}
      {{/let}}
    {{/if}}
  </template>
}

export default CommandItem
