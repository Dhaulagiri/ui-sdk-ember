import Component from "@glimmer/component"
import { Resizable } from "ember-ui-sdk/resizable"
import { useLog } from "../../../shared/ember/log"

export default class Complete extends Component {
  log = useLog(this)

  onLayoutCommit = (layout: number[], details: { reason: string }) => {
    this.log(`Saved ${layout.map(Math.round).join(" / ")} (${details.reason})`)
  }

  <template>
    <Resizable @onLayoutCommit={{this.onLayoutCommit}} as |r|>
      <r.Panel @defaultSize={{40}} @minSize={{20}}>
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
  </template>
}
