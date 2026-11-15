import { renderComponent } from "@ember/renderer"
import ResizableFixture from "./ResizableFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(ResizableFixture, { into: root })
}

export { mount }
