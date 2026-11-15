import { renderComponent } from "@ember/renderer"
import Fixture from "./OTPInputFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(Fixture, { into: root })
}

export { mount }
