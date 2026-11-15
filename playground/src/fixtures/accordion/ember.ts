import { renderComponent } from "@ember/renderer"
import Fixture from "./AccordionFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(Fixture, { into: root })
}

export { mount }
