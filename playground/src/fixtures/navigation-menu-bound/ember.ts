import { renderComponent } from "@ember/renderer"
import NavigationMenuBoundFixture from "./NavigationMenuBoundFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(NavigationMenuBoundFixture, { into: root })
}

export { mount }
