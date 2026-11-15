import { renderComponent } from "@ember/renderer"
import Fixture from "./ToolbarFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(Fixture, { into: root })
}

export { mount }
