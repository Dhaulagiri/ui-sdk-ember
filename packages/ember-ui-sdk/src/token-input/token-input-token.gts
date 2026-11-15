import Component from "@glimmer/component"
import { tokenInput } from "@ui-sdk/core/token-input"
import { usePart, type PartSignature } from "../use-part"

/** A token's content, inside `Tokens`, with its state for styling. */
class TokenInputToken extends Component<
  PartSignature<typeof tokenInput, "token", HTMLSpanElement, { token: string }>
> {
  part = usePart(
    this,
    () => this.args.handle,
    "token",
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

export default TokenInputToken
