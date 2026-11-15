import { renderComponent } from "@ember/renderer"
import CarouselFixture from "./CarouselFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(CarouselFixture, { into: root })
}

export { mount }
