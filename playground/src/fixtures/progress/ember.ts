import { renderComponent } from "@ember/renderer"
import ProgressFixture from "./ProgressFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(ProgressFixture, { into: root })
}

export { mount }
