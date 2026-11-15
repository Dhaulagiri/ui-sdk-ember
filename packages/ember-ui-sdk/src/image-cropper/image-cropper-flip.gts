import Component from "@glimmer/component"
import { imageCropper } from "@ui-sdk/core/image-cropper"
import { usePart, type PartSignature } from "../use-part"

/** A button that mirrors the image, left to right or, with `direction="vertical"`, top to bottom. */
class ImageCropperFlip extends Component<
  PartSignature<typeof imageCropper, "flip", HTMLButtonElement>
> {
  part = usePart(this, () => this.args.handle, "flip")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <button ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</button>
    {{/if}}
  </template>
}

export default ImageCropperFlip
