import { renderComponent } from "@ember/renderer"
import Fixture from "./ScrollAreaFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(Fixture, { into: root })
}

export { mount }
