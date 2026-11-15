import Component from "@glimmer/component"
import { imageCropper } from "@ui-sdk/core/image-cropper"
import { usePart, type PartSignature } from "../use-part"

/** The image, from the root's `src`, turned and flipped. Give it an `alt`. */
class ImageCropperImage extends Component<
  PartSignature<typeof imageCropper, "image", HTMLElement>
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

export default ImageCropperImage
