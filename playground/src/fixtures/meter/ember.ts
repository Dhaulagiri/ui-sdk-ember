import { renderComponent } from "@ember/renderer"
import MeterFixture from "./MeterFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(MeterFixture, { into: root })
}

export { mount }
