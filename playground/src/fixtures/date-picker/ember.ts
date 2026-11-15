import { renderComponent } from "@ember/renderer"
import DatePickerFixture from "./DatePickerFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(DatePickerFixture, { into: root })
}

export { mount }
