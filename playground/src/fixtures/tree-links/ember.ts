import { renderComponent } from "@ember/renderer"
import TreeLinksFixture from "./TreeLinksFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(TreeLinksFixture, { into: root })
}

export { mount }
