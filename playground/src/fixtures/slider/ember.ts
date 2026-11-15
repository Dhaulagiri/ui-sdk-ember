import { renderComponent } from "@ember/renderer"
import SliderFixture from "./SliderFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(SliderFixture, { into: root })
}

export { mount }
