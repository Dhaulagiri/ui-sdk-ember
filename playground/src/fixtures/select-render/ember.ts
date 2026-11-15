import { renderComponent } from "@ember/renderer"
import SelectRenderFixture from "./SelectRenderFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(SelectRenderFixture, { into: root })
}

export { mount }
