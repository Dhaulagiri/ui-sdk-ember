import Component from "@glimmer/component"
import { tooltip } from "@ui-sdk/core/tooltip"
import { usePart, type PartSignature } from "../use-part"
import TooltipShortcut from "./tooltip-shortcut.gts"

// The bound trigger, once its tooltip is known.
class TooltipTriggerBinding extends Component<
  PartSignature<typeof tooltip, "trigger", HTMLButtonElement>
> {
  part = usePart(this, () => this.args.handle, "trigger")

  <template>
    {{#let
      (hash
        part=this.part.modifier
        state=this.part.state
        Shortcut=(component TooltipShortcut handle=@handle)
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

export default TooltipTriggerBinding
