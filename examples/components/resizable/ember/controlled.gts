import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { Resizable } from "ember-ui-sdk/resizable"
import { useLog } from "../../../shared/ember/log"

const format = (layout: number[]) => layout.map(Math.round).join(" / ")

export default class Controlled extends Component {
  log = useLog(this)
  @tracked layout = [30, 70]

  split = () => {
    this.layout = [50, 50]
  }

  reset = () => {
    this.layout = [30, 70]
  }

  onLayoutChange = (next: number[], details: { reason: string }) => {
    if (format(next) !== format(this.layout)) {
      this.log(`${format(next)} (${details.reason})`)
    }
    this.layout = next
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.split}}>Split Evenly</button>
        <button type="button" {{on "click" this.reset}}>Reset</button>
      </div>
      <Resizable
        @layout={{this.layout}}
        @onLayoutChange={{this.onLayoutChange}}
        as |r|
      >
        <r.Panel @minSize={{20}}>
          <h3>Files</h3>
          <ul>
            <li>page.tsx</li>
            <li>layout.tsx</li>
            <li>globals.css</li>
          </ul>
        </r.Panel>
        <r.Handle aria-label="Resize files" />
        <r.Panel @minSize={{20}}>
          <h3>page.tsx</h3>
          <span data-slot="hint">Saved just now</span>
        </r.Panel>
      </Resizable>
    </div>
  </template>
}
