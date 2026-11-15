import { renderComponent } from "@ember/renderer"
import Fixture from "./FormFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(Fixture, { into: root })
}

export { mount }
