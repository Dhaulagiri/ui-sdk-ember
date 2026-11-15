import { renderComponent } from "@ember/renderer"
import CommandFixture from "./CommandFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(CommandFixture, { into: root })
}

export { mount }
