import { hash } from "@ember/helper"
import Component from "@glimmer/component"
import { popover } from "@ui-sdk/core/popover"
import { usePart, type PartSignature } from "../use-part"
import PopoverShortcut from "./popover-shortcut.gts"

// The bound trigger, once its popover is known.
class PopoverTriggerBinding extends Component<
  PartSignature<typeof popover, "trigger", HTMLButtonElement>
> {
  part = usePart(this, () => this.args.handle, "trigger")

  <template>
    {{#let
      (hash
        part=this.part.modifier
        state=this.part.state
        Shortcut=(component PopoverShortcut handle=@handle shortcut=@shortcut)
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

export default PopoverTriggerBinding
