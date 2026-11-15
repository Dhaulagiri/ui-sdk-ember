import Component from "@glimmer/component"
import { avatar } from "@ui-sdk/core/avatar"
import { usePart, type PartSignature } from "../use-part"

/** Shown while there's no loaded image, after its `@delay`. */
class AvatarFallback extends Component<
  PartSignature<typeof avatar, "fallback", HTMLSpanElement>
> {
  part = usePart(this, () => this.args.handle, "fallback")

  <template>
    {{#if this.part.present}}{{#if @render}}
        {{yield this.part.yielded}}
      {{else}}
        <span ...attributes {{this.part.modifier}}>{{yield
            this.part.yielded
          }}</span>
      {{/if}}{{/if}}
  </template>
}

export default AvatarFallback
