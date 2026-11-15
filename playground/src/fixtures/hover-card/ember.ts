import { renderComponent } from "@ember/renderer"
import HoverCardFixture from "./HoverCardFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(HoverCardFixture, { into: root })
}

export { mount }
