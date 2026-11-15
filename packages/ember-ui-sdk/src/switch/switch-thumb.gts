import Component from "@glimmer/component"
import { switchPrimitive } from "@ui-sdk/core/switch"
import { usePart, type PartSignature } from "../use-part"

/** The thumb that slides along the switch as it turns on or off. */
class SwitchThumb extends Component<
  PartSignature<typeof switchPrimitive, "thumb", HTMLSpanElement>
> {
  part = usePart(this, () => this.args.handle, "thumb")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <span ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</span>
    {{/if}}
  </template>
}

export default SwitchThumb
