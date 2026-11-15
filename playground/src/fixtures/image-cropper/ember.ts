import { renderComponent } from "@ember/renderer"
import ImageCropperFixture from "./ImageCropperFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(ImageCropperFixture, { into: root })
}

export { mount }
