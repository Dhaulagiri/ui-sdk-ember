import { renderComponent } from "@ember/renderer"
import Fixture from "./PaginationFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(Fixture, { into: root })
}

export { mount }
