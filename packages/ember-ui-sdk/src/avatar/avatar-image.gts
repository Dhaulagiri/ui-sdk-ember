import Component from "@glimmer/component"
import { avatar } from "@ui-sdk/core/avatar"
import { usePart, type PartSignature } from "../use-part"

/** A real <img>, hidden until it loads. */
class AvatarImage extends Component<
  PartSignature<typeof avatar, "image", HTMLImageElement>
> {
  part = usePart(this, () => this.args.handle, "image")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <img ...attributes {{this.part.modifier}} />
    {{/if}}
  </template>
}

export default AvatarImage
