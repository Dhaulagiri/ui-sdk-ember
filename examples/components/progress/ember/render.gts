import Component from "@glimmer/component"
import { Progress } from "ember-ui-sdk/progress"

export default class Render extends Component {
  chargeText = (state: { status: string; text: string }) =>
    state.status === "complete" ? "Charged" : `${state.text} charged`

  variant = (percent: number | null) =>
    (percent ?? 0) < 20 ? "destructive" : undefined

  <template>
    <Progress @value={{18}} as |p|>
      <p.Label>Battery</p.Label>
      <p.Value as |v|>{{this.chargeText v.state}}</p.Value>
      <p.Track @render={{true}} as |t|>
        <span {{t.part}}>
          <p.Indicator @render={{true}} as |i|>
            <div {{i.part}} data-variant={{this.variant i.state.percent}}></div>
          </p.Indicator>
        </span>
      </p.Track>
    </Progress>
  </template>
}
