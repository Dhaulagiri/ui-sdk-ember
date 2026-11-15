import { renderComponent } from "@ember/renderer"
import ComboboxFixture from "./ComboboxFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(ComboboxFixture, { into: root })
}

export { mount }
