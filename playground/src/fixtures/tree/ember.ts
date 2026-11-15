import { renderComponent } from "@ember/renderer"
import TreeFixture from "./TreeFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(TreeFixture, { into: root })
}

export { mount }
