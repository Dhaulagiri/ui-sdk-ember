import Component from "@glimmer/component"
import { otpInput } from "@ui-sdk/core/otp-input"
import { usePart, type PartModifier, type PartSignature } from "../use-part"

/** The real input over the slots, which takes focus and is named. The root renders it. */
class OTPInputControl extends Component<
  PartSignature<
    typeof otpInput,
    "control",
    HTMLInputElement,
    {
      id?: string
      autofocus?: boolean
      fieldModifier?: PartModifier
      ariaLabel?: string
      ariaLabelledby?: string
      ariaDescribedby?: string
      ariaInvalid?: boolean | "true" | "false"
    }
  >
> {
  part = usePart(this, () => this.args.handle, "control")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <input
        id={{@id}}
        autofocus={{@autofocus}}
        aria-label={{@ariaLabel}}
        aria-labelledby={{@ariaLabelledby}}
        aria-describedby={{@ariaDescribedby}}
        aria-invalid={{@ariaInvalid}}
        ...attributes
        {{this.part.modifier}}
        {{@fieldModifier}}
      />
    {{/if}}
  </template>
}

export default OTPInputControl
