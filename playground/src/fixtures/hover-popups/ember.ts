import { renderComponent } from "@ember/renderer"
import HoverPopupsFixture from "./HoverPopupsFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(HoverPopupsFixture, { into: root })
}

export { mount }
