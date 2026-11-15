import { renderComponent } from "@ember/renderer"
import AutocompleteFixture from "./AutocompleteFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(AutocompleteFixture, { into: root })
}

export { mount }
