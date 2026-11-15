import { renderComponent } from "@ember/renderer"
import { exposeLayers } from "tests/fixtures/perf.ts"
import LeaksFixture from "./LeaksFixture.gts"

function mount(root: HTMLElement) {
  exposeLayers()
  renderComponent(LeaksFixture, { into: root })
}

export { mount }
