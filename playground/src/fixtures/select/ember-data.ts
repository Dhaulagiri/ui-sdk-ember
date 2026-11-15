import { renderComponent } from "@ember/renderer"
import SelectFixture from "./SelectFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(SelectFixture, { into: root, args: { data: true } })
}

export { mount }
