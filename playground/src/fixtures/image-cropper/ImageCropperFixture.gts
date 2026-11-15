import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import {
  createImageCropperController,
  ImageCropper,
  type ImageCropperCropChangeDetails,
  type ImageCropperCropCommitDetails,
} from "ember-ui-sdk/image-cropper"
import {
  describeCrop,
  imageCropperFixture,
} from "tests/fixtures/image-cropper.ts"
import { imageCropperOptions } from "tests/fixtures/page.ts"

const { cancel, ...options } = imageCropperOptions()

export default class ImageCropperFixture extends Component {
  f = imageCropperFixture
  options = options as ReturnType<typeof imageCropperOptions>
  controller = createImageCropperController()
  @tracked action = ""
  @tracked committed = ""

  onCropChange = (
    crop: Parameters<typeof describeCrop>[0],
    details: ImageCropperCropChangeDetails
  ) => {
    if (cancel && details.reason !== "image-load") {
      return details.cancel()
    }
    this.action = `${describeCrop(crop)}:${details.reason}`
  }

  onCropCommit = (
    crop: Parameters<typeof describeCrop>[0],
    details: ImageCropperCropCommitDetails
  ) => {
    this.committed = `${describeCrop(crop)}:${details.reason}`
  }

  useCorner = () =>
    this.controller.setCrop({ x: 0, y: 0, width: 100, height: 100 })

  <template>
    <div class="fixture">
      <button type="button">Before</button>
      <ImageCropper
        aria-label={{this.f.label}}
        @src={{this.f.src}}
        @mode={{this.options.mode}}
        @shape={{this.options.shape}}
        @disabled={{this.options.disabled}}
        @aspectRatio={{this.options.aspectRatio}}
        @defaultCrop={{this.options.defaultCrop}}
        @controller={{this.controller}}
        @onCropChange={{this.onCropChange}}
        @onCropCommit={{this.onCropCommit}}
        as |c|
      >
        <c.Viewport>
          <c.Image alt={{this.f.alt}} />
          <c.Selection>
            <c.Grid />
            {{#each this.f.handles as |position|}}
              <c.Handle @position={{position}} />
            {{/each}}
          </c.Selection>
        </c.Viewport>
        <c.Zoom />
        <c.Rotate>Rotate</c.Rotate>
        <c.Flip>Flip</c.Flip>
      </ImageCropper>
      <button type="button">After</button>
      <button type="button" {{on "click" this.useCorner}}>Use corner</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
      <output aria-label="Committed">{{this.committed}}</output>
    </div>
  </template>
}
