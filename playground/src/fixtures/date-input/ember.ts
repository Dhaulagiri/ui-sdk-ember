import { renderComponent } from "@ember/renderer"
import DateInputFixture from "./DateInputFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(DateInputFixture, { into: root })
}

export { mount }
