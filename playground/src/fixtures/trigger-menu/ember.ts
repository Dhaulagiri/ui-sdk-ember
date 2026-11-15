import { renderComponent } from "@ember/renderer"
import TriggerMenuFixture from "./TriggerMenuFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(TriggerMenuFixture, { into: root })
}

export { mount }
