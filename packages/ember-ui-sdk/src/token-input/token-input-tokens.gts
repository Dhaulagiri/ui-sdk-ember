import { registerDestructor } from "@ember/destroyable"
import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { renderVersion } from "@ui-sdk/core/renderer"
import type { tokenInput } from "@ui-sdk/core/token-input"
import { afterRender, type PrimitiveHandle } from "../use-primitive"
import TokenInputToken from "./token-input-token.gts"
import TokenInputTokenRemove from "./token-input-token-remove.gts"

/** Renders each token's content into its place in the editor. Yields the token and its `Token` and `Remove` parts. */
class TokenInputTokens extends Component<{
  Args: { handle: PrimitiveHandle<typeof tokenInput> }
  Blocks: { default: [any, any] }
}> {
  @tracked version = 0

  constructor(owner: Owner, args: TokenInputTokens["args"]) {
    super(owner, args)
    const { handle } = args
    handle.api.internal.setCustom(true)
    const stop = handle.instance.subscribe(() => {
      const next = renderVersion(handle.instance)
      afterRender(() => (this.version = next))
    })
    registerDestructor(this, () => {
      stop()
      handle.api.internal.setCustom(false)
    })
  }

  get hosts() {
    this.version
    return this.args.handle.api.internal.hosts()
  }

  <template>
    {{~#each this.hosts key="id" as |host|~}}
      {{~#in-element host.host insertBefore=null~}}
        {{~yield
          host.token
          (hash
            Token=(component TokenInputToken handle=@handle token=host.id)
            Remove=(component
              TokenInputTokenRemove handle=@handle token=host.id
            )
          )
        ~}}
      {{~/in-element~}}
    {{~/each~}}
  </template>
}

export default TokenInputTokens
