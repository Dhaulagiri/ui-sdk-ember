import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { tracked } from "@glimmer/tracking"
import { Field } from "ember-ui-sdk/field"
import { Slider } from "ember-ui-sdk/slider"
import { useLog } from "../../../shared/ember/log"

export default class Controlled extends Component {
  log = useLog(this)
  @tracked value: number[] = [0.3, 0.7]

  reset = () => {
    this.value = [0.3, 0.7]
  }

  onValueChange = (next: number | number[], details: { reason: string }) => {
    this.value = [next].flat() as number[]
    this.log(`${[next].flat().join(" – ")} (${details.reason})`)
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.reset}}>Reset</button>
      </div>
      <Field as |f|>
        <Slider
          @value={{this.value}}
          @onValueChange={{this.onValueChange}}
          @min={{0}}
          @max={{1}}
          @step={{0.1}}
          @field={{f.field}}
          as |s|
        >
          <div data-slot="row">
            <f.Label>Temperature</f.Label>
            <s.Value />
          </div>
          <s.Control>
            <s.Track>
              <s.Indicator />
              <s.Thumb @index={{0}} aria-label="Minimum temperature" />
              <s.Thumb @index={{1}} aria-label="Maximum temperature" />
            </s.Track>
          </s.Control>
        </Slider>
      </Field>
    </div>
  </template>
}
