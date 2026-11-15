import Component from "@glimmer/component"
import { drawer } from "@ui-sdk/core/drawer"
import { usePart, type PartSignature } from "../use-part"
import DrawerShortcut from "./drawer-shortcut.gts"

// The bound trigger, once its drawer is known.
class DrawerTriggerBinding extends Component<
  PartSignature<typeof drawer, "trigger", HTMLButtonElement>
> {
  part = usePart(this, () => this.args.handle, "trigger")

  <template>
    {{#let
      (hash
        part=this.part.modifier
        state=this.part.state
        Shortcut=(component DrawerShortcut handle=@handle shortcut=@shortcut)
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

export default DrawerTriggerBinding
