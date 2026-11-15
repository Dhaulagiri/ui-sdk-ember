import { renderComponent } from "@ember/renderer"
import Cases from "./Cases.gts"

function mount(root: HTMLElement) {
  renderComponent(Cases, { into: root })
}

export { mount }
