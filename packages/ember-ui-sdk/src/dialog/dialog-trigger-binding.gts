import { hash } from "@ember/helper"
import Component from "@glimmer/component"
import { dialog } from "@ui-sdk/core/dialog"
import { usePart, type PartSignature } from "../use-part"
import DialogShortcut from "./dialog-shortcut.gts"

// The bound trigger, once its dialog is known.
class DialogTriggerBinding extends Component<
  PartSignature<typeof dialog, "trigger", HTMLButtonElement>
> {
  part = usePart(this, () => this.args.handle, "trigger")

  <template>
    {{#let
      (hash
        part=this.part.modifier
        state=this.part.state
        Shortcut=(component DialogShortcut handle=@handle shortcut=@shortcut)
      )
      as |trigger|
    }}
      {{#if @render}}
        {{yield trigger}}
      {{else}}
        <button ...attributes {{this.part.modifier}}>{{yield trigger}}</button>
      {{/if}}
    {{/let}}
  </template>
}

export default DialogTriggerBinding
