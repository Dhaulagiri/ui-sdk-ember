import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { tracked } from "@glimmer/tracking"
import { cropImage, type ImageCrop } from "@ui-sdk/core/image"
import { ImageCropper } from "ember-ui-sdk/image-cropper"

const photo = `data:image/svg+xml,${encodeURIComponent(
  `<svg xmlns="http://www.w3.org/2000/svg" width="640" height="420"><rect width="640" height="420" fill="#e5e5e5"/><circle cx="460" cy="150" r="56" fill="#fafafa"/><path d="M0 280 120 170l110 100 120-130 130 125 90-60 70 40v175H0z" fill="#a3a3a3"/><path d="M0 330l160-80 120 70 150-80 210 85v95H0z" fill="#525252"/><path d="M0 380q160-35 320-10t320-5v55H0z" fill="#262626"/></svg>`
)}`

export default class Avatar extends Component {
  photo = photo
  @tracked crop: ImageCrop | undefined = undefined
  @tracked avatar: string | undefined = undefined

  onCropChange = (next: ImageCrop) => {
    this.crop = next
  }

  save = async () => {
    if (!this.crop) {
      return
    }
    const file = await cropImage(photo, this.crop, {
      width: 128,
      shape: "circle",
    })
    if (this.avatar) {
      URL.revokeObjectURL(this.avatar)
    }
    this.avatar = URL.createObjectURL(file)
  }

  willDestroy() {
    super.willDestroy()
    if (this.avatar) {
      URL.revokeObjectURL(this.avatar)
    }
  }

  <template>
    <ImageCropper
      @crop={{this.crop}}
      @onCropChange={{this.onCropChange}}
      @src={{this.photo}}
      @mode="frame"
      @aspectRatio={{1}}
      @shape="circle"
      @maxZoom={{4}}
      aria-label="Profile photo"
      as |c|
    >
      <c.Viewport>
        <c.Image alt="Mountains at sunset" />
        <c.Selection />
      </c.Viewport>
      <div data-slot="row">
        <c.Zoom />
        <c.Rotate>Rotate</c.Rotate>
      </div>
      <div data-slot="row">
        <button type="button" {{on "click" this.save}}>Save Avatar</button>
        {{#if this.avatar}}
          <img
            data-slot="image-cropper-avatar"
            src={{this.avatar}}
            alt="Your new avatar"
          />
        {{/if}}
      </div>
    </ImageCropper>
  </template>
}
