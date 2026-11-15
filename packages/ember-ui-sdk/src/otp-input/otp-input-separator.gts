import Component from "@glimmer/component"
import { otpInput } from "@ui-sdk/core/otp-input"
import { usePart, type PartSignature } from "../use-part"

/** Drawn between groups, like a dash. */
class OTPInputSeparator extends Component<
  PartSignature<typeof otpInput, "separator", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "separator")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <div ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</div>
    {{/if}}
  </template>
}

export default OTPInputSeparator
