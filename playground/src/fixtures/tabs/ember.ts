import { renderComponent } from "@ember/renderer"
import TabsFixture from "./TabsFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(TabsFixture, { into: root })
}

export { mount }
