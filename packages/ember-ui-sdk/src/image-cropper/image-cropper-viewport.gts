import Component from "@glimmer/component"
import { imageCropper } from "@ui-sdk/core/image-cropper"
import { usePart, type PartSignature } from "../use-part"

/** The area the image shows in. Give it a size; its padding keeps the image off its edges. In a frame, a pointer pans the image and the wheel zooms it. */
class ImageCropperViewport extends Component<
  PartSignature<typeof imageCropper, "viewport", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "viewport")

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

export default ImageCropperViewport
