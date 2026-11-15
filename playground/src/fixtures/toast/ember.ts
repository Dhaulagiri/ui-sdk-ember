import { renderComponent } from "@ember/renderer"
import ToastFixture from "./ToastFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(ToastFixture, { into: root })
}

export { mount }
