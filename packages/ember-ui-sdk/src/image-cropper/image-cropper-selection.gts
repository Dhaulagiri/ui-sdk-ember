import Component from "@glimmer/component"
import { imageCropper } from "@ui-sdk/core/image-cropper"
import { usePart, type PartSignature } from "../use-part"

/** The crop. A pointer drags it in a box; arrows move it, plus and minus zoom, and R turns the image. */
class ImageCropperSelection extends Component<
  PartSignature<typeof imageCropper, "selection", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "selection")

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

export default ImageCropperSelection
