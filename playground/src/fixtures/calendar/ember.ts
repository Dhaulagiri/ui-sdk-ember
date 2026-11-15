import { renderComponent } from "@ember/renderer"
import CalendarFixture from "./CalendarFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(CalendarFixture, { into: root })
}

export { mount }
