import Component from "@glimmer/component"
import { Meter } from "ember-ui-sdk/meter"

export default class Render extends Component {
  variant = (percent: number) => (percent >= 90 ? "destructive" : undefined)

  <template>
    <Meter @value={{91}} as |m|>
      <m.Label>Disk</m.Label>
      <m.Value as |v|>{{v.state.text}} used</m.Value>
      <m.Track @render={{true}} as |t|>
        <span {{t.part}}>
          <m.Indicator @render={{true}} as |i|>
            <div {{i.part}} data-variant={{this.variant i.state.percent}}></div>
          </m.Indicator>
        </span>
      </m.Track>
    </Meter>
  </template>
}
