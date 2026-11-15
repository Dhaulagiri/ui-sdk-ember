import { renderComponent } from "@ember/renderer"
import ListboxFixture from "./ListboxFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(ListboxFixture, { into: root })
}

export { mount }
