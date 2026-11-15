import Component from "@glimmer/component"
import { imageCropper } from "@ui-sdk/core/image-cropper"
import { usePart, type PartSignature } from "../use-part"

/** A range input for the zoom, from 1 to `maxZoom`. */
class ImageCropperZoom extends Component<
  PartSignature<typeof imageCropper, "zoom", HTMLInputElement>
> {
  part = usePart(this, () => this.args.handle, "zoom")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <input ...attributes {{this.part.modifier}} />
    {{/if}}
  </template>
}

export default ImageCropperZoom
