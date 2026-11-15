import { renderComponent } from "@ember/renderer"
import ListboxPickerFixture from "./ListboxPickerFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(ListboxPickerFixture, { into: root })
}

export { mount }
