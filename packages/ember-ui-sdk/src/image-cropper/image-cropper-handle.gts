import Component from "@glimmer/component"
import { imageCropper } from "@ui-sdk/core/image-cropper"
import { usePart, type PartSignature } from "../use-part"

/** An edge or corner of the selection, by its `position`, that resizes it in a box. */
class ImageCropperHandle extends Component<
  PartSignature<typeof imageCropper, "handle", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "handle")

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

export default ImageCropperHandle
