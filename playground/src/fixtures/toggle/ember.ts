import { renderComponent } from "@ember/renderer"
import ToggleFixture from "./ToggleFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(ToggleFixture, { into: root })
}

export { mount }
