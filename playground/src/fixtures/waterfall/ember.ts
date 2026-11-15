import { renderComponent } from "@ember/renderer"
import WaterfallFixture from "./WaterfallFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(WaterfallFixture, { into: root })
}

export { mount }
