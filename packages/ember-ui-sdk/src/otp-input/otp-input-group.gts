import Component from "@glimmer/component"
import { otpInput } from "@ui-sdk/core/otp-input"
import { usePart, type PartSignature } from "../use-part"

/** Lays out a run of slots. */
class OTPInputGroup extends Component<
  PartSignature<typeof otpInput, "group", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "group")

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

export default OTPInputGroup
