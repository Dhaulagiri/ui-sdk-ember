import Component from "@glimmer/component"
import { otpInput } from "@ui-sdk/core/otp-input"
import { usePart, type PartSignature } from "../use-part"

/** One character of the code. Without content, it shows the character. */
class OTPInputSlot extends Component<
  PartSignature<typeof otpInput, "slot", HTMLDivElement>
> {
  part = usePart(
    this,
    () => this.args.handle,
    "slot",
    () => ({ id: String(this.args.index) })
  )

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <div ...attributes {{this.part.modifier}}>{{#if (has-block)}}{{yield
            this.part.yielded
          }}{{else}}{{this.part.state.char}}{{/if}}</div>
    {{/if}}
  </template>
}

export default OTPInputSlot
