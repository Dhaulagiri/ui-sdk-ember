import { renderComponent } from "@ember/renderer"
import DialogFixture from "./DialogFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(DialogFixture, { into: root })
}

export { mount }
