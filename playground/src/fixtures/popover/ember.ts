import { renderComponent } from "@ember/renderer"
import PopoverFixture from "./PopoverFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(PopoverFixture, { into: root })
}

export { mount }
