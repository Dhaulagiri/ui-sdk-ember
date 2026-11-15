import { renderComponent } from "@ember/renderer"
import TooltipFixture from "./TooltipFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(TooltipFixture, { into: root })
}

export { mount }
