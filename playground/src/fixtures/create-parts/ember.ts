import { renderComponent } from "@ember/renderer"
import CreatePartsFixture from "./CreatePartsFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(CreatePartsFixture, { into: root })
}

export { mount }
