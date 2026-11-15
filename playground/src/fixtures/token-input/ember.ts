import { renderComponent } from "@ember/renderer"
import TokenInputFixture from "./TokenInputFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(TokenInputFixture, { into: root })
}

export { mount }
