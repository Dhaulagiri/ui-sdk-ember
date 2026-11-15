import { renderComponent } from "@ember/renderer"
import ComboboxRenderFixture from "./ComboboxRenderFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(ComboboxRenderFixture, { into: root })
}

export { mount }
