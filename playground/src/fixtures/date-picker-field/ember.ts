import { renderComponent } from "@ember/renderer"
import DatePickerFieldFixture from "./DatePickerFieldFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(DatePickerFieldFixture, { into: root })
}

export { mount }
