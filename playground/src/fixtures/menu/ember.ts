import { renderComponent } from "@ember/renderer"
import MenuFixture from "./MenuFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(MenuFixture, { into: root })
}

export { mount }
