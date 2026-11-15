import { renderComponent } from "@ember/renderer"
import AutocompleteRenderFixture from "./AutocompleteRenderFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(AutocompleteRenderFixture, { into: root })
}

export { mount }
