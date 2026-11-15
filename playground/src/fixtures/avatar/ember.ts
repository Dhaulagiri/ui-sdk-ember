import { renderComponent } from "@ember/renderer"
import AvatarFixture from "./AvatarFixture.gts"

function mount(root: HTMLElement) {
  renderComponent(AvatarFixture, { into: root })
}

export { mount }
