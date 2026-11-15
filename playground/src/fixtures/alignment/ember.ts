import { renderComponent } from "@ember/renderer"
import AlignmentFixture from "./AlignmentFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(AlignmentFixture, { into: root })
}

export { mount }
