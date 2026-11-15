import Component from "@glimmer/component"
import { tokenInput } from "@ui-sdk/core/token-input"
import { usePart, type PartSignature } from "../use-part"

/** Removes its token when pressed. Hidden from assistive technology: the keyboard's way is Backspace. */
class TokenInputTokenRemove extends Component<
  PartSignature<
    typeof tokenInput,
    "token-remove",
    HTMLSpanElement,
    { token: string }
  >
> {
  part = usePart(
    this,
    () => this.args.handle,
    "token-remove",
    () => ({
      id: this.args.token,
      token: this.args.token,
    })
  )

  <template>
    {{~#if @render~}}
      {{~yield this.part.yielded~}}
    {{~else~}}
      <span ...attributes {{this.part.modifier}}>{{~yield
          this.part.yielded
        ~}}</span>
    {{~/if~}}
  </template>
}

export default TokenInputTokenRemove
