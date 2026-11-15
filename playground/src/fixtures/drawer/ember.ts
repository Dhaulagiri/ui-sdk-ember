import { renderComponent } from "@ember/renderer"
import DrawerFixture from "./DrawerFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(DrawerFixture, { into: root })
}

export { mount }
