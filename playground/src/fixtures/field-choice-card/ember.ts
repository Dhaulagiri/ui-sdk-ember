import { renderComponent } from "@ember/renderer"
import Fixture from "./FieldChoiceCardFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(Fixture, { into: root })
}

export { mount }
