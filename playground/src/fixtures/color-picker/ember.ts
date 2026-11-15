import { renderComponent } from "@ember/renderer"
import ColorPickerFixture from "./ColorPickerFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(ColorPickerFixture, { into: root })
}

export { mount }
