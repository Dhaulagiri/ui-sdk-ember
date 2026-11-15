import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Progress } from "ember-ui-sdk/progress"
import { progressFixture } from "tests/fixtures/progress.ts"

const { upload, loading, files, disk } = progressFixture
const bars = [
  { label: loading.label, value: null },
  {
    label: files.label,
    value: files.value,
    max: files.max,
    getValueLabel: (value: number | null) => files.valueLabel(value!),
  },
  {
    label: disk.label,
    value: disk.value,
    max: disk.max,
    format: disk.format,
  },
]

export default class ProgressFixture extends Component {
  upload = upload
  bars = bars
  @tracked value = upload.value

  advance = () => (this.value = Math.min(100, this.value + upload.step))
  restart = () => (this.value = upload.value)

  <template>
    <div class="fixture">
      <button>Before</button>
      <Progress class="gauge" @value={{this.value}} as |p|>
        <p.Label>{{upload.label}}</p.Label>
        <p.Value class="gauge-value" />
        <p.Track class="gauge-track"><p.Indicator
            class="gauge-indicator"
          /></p.Track>
      </Progress>
      {{#each this.bars key="label" as |bar|}}
        <Progress
          class="gauge"
          @value={{bar.value}}
          @max={{bar.max}}
          @format={{bar.format}}
          @getValueLabel={{bar.getValueLabel}}
          as |p|
        >
          <p.Label>{{bar.label}}</p.Label>
          <p.Value class="gauge-value" />
          <p.Track class="gauge-track"><p.Indicator
              class="gauge-indicator"
            /></p.Track>
        </Progress>
      {{/each}}
      <button {{on "click" this.advance}}>Advance</button>
      <button {{on "click" this.restart}}>Restart</button>
      <button>After</button>
      <output role="status" aria-label="Last action"></output>
    </div>
  </template>
}
