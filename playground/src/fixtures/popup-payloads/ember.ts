import { renderComponent } from "@ember/renderer"
import PopupPayloadsFixture from "./PopupPayloadsFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(PopupPayloadsFixture, { into: root })
}

export { mount }
