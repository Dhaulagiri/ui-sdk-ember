import { renderComponent } from "@ember/renderer"
import MenubarFixture from "./MenubarFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(MenubarFixture, { into: root })
}

export { mount }
