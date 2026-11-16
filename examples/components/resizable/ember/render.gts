import Component from "@glimmer/component"
import { Resizable } from "ember-ui-sdk/resizable"

const percent = (size: number) => `${Math.round(size)}%`

export default class Render extends Component {
  percent = percent

  <template>
    <Resizable as |r|>
      <r.Panel @defaultSize={{35}} @minSize={{20}} @collapsible={{true}} as |p|>
        <h3>Files</h3>
        <span data-slot="hint">{{if
            p.state.collapsed
            "Collapsed"
            (this.percent p.state.size)
          }}</span>
      </r.Panel>
      <r.Handle aria-label="Resize files" @render={{true}} as |h|>
        <div {{h.part}}></div>
      </r.Handle>
      <r.Panel @minSize={{30}} as |p|>
        <h3>Editor</h3>
        <span data-slot="hint">{{this.percent p.state.size}}</span>
      </r.Panel>
    </Resizable>
  </template>
}
