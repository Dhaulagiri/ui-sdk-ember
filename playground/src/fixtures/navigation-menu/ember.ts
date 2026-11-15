import { renderComponent } from "@ember/renderer"
import NavigationMenuFixture from "./NavigationMenuFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(NavigationMenuFixture, { into: root })
}

export { mount }
