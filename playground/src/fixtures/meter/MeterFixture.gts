import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import {
  Meter,
  MeterIndicator,
  MeterLabel,
  MeterTrack,
  MeterValue,
} from "ember-ui-sdk/meter"
import { meterFixture } from "tests/fixtures/meter.ts"

const { storage, requests, disk, score } = meterFixture
const meters = [
  {
    label: requests.label,
    value: requests.value,
    max: requests.max,
    getValueLabel: requests.valueLabel,
  },
  {
    label: disk.label,
    value: disk.value,
    max: disk.max,
    format: disk.format,
  },
  { label: score.label, value: score.value, min: score.min, max: score.max },
]

export default class MeterFixture extends Component {
  storage = storage
  meters = meters
  @tracked value = storage.value

  fill = () => (this.value += storage.step)
  reset = () => (this.value = storage.value)

  <template>
    <div class="fixture">
      <button>Before</button>
      <Meter class="gauge" @value={{this.value}} as |m|>
        <m.Label>{{storage.label}}</m.Label>
        <m.Value class="gauge-value" />
        <m.Track class="gauge-track"><m.Indicator
            class="gauge-indicator"
          /></m.Track>
      </Meter>
      {{#each this.meters key="label" as |meter|}}
        <Meter
          class="gauge"
          @value={{meter.value}}
          @min={{meter.min}}
          @max={{meter.max}}
          @format={{meter.format}}
          @getValueLabel={{meter.getValueLabel}}
          as |m|
        >
          <m.Label>{{meter.label}}</m.Label>
          <m.Value class="gauge-value" />
          <m.Track class="gauge-track"><m.Indicator
              class="gauge-indicator"
            /></m.Track>
        </Meter>
      {{/each}}
      <button {{on "click" this.fill}}>Fill</button>
      <button {{on "click" this.reset}}>Reset</button>
      <button>After</button>
      <output role="status" aria-label="Last action"></output>
    </div>
  </template>
}
