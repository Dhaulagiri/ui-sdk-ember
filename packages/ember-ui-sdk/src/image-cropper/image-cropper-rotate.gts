import Component from "@glimmer/component"
import { imageCropper } from "@ui-sdk/core/image-cropper"
import { usePart, type PartSignature } from "../use-part"

/** A button that turns the image a quarter clockwise. */
class ImageCropperRotate extends Component<
  PartSignature<typeof imageCropper, "rotate", HTMLButtonElement>
> {
  part = usePart(this, () => this.args.handle, "rotate")

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

export default ImageCropperRotate
