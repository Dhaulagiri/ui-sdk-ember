import { renderComponent } from "@ember/renderer"
import SelectFieldFixture from "./SelectFieldFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(SelectFieldFixture, { into: root })
}

export { mount }
