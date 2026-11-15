import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Meter } from "ember-ui-sdk/meter"

const level = (percent: number) => (percent >= 80 ? "is-high" : "is-ok")

export default class MeterRenderFixture extends Component {
  @tracked value = 40

  fill = () => (this.value = 90)

  <template>
    <div class="fixture">
      <button>Before</button>
      <Meter @value={{this.value}} @render={{true}} as |m|>
        <section
          {{m.part}}
          aria-label="Memory"
          class="gauge {{level m.state.percent}}"
        >
          <m.Value as |v|>{{v.state.text}} used</m.Value>
          <m.Track class="gauge-track"><m.Indicator
              class="gauge-indicator"
            /></m.Track>
        </section>
      </Meter>
      <button {{on "click" this.fill}}>Fill</button>
      <button>After</button>
      <output role="status" aria-label="Last action"></output>
    </div>
  </template>
}
