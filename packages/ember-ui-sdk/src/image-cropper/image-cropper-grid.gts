import Component from "@glimmer/component"
import { imageCropper } from "@ui-sdk/core/image-cropper"
import { usePart, type PartSignature } from "../use-part"

/** Lines across the selection in thirds, for CSS to draw, with `data-dragging` during a drag. */
class ImageCropperGrid extends Component<
  PartSignature<typeof imageCropper, "grid", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "grid")

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

export default ImageCropperGrid
