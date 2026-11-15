import { renderComponent } from "@ember/renderer"
import CommandRenderFixture from "./CommandRenderFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(CommandRenderFixture, { into: root })
}

export { mount }
