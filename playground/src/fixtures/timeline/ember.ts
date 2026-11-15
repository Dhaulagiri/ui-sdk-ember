import { renderComponent } from "@ember/renderer"
import TimelineFixture from "./TimelineFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(TimelineFixture, { into: root })
}

export { mount }
