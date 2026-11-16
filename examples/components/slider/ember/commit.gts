import { Field } from "ember-ui-sdk/field"
import { Slider } from "ember-ui-sdk/slider"
import { useLog } from "../../../shared/ember/log"
import Component from "@glimmer/component"

export default class Commit extends Component {
  log = useLog(this)

  onValueCommit = (value: number | number[], details: { reason: string }) => {
    this.log(`Saved ${value} (${details.reason})`)
  }

  <template>
    <Field as |f|>
      <Slider
        @onValueCommit={{this.onValueCommit}}
        @defaultValue={{50}}
        @field={{f.field}}
        as |s|
      >
        <div data-slot="row">
          <f.Label>Brightness</f.Label>
          <s.Value />
        </div>
        <s.Control>
          <s.Track>
            <s.Indicator />
            <s.Thumb />
          </s.Track>
        </s.Control>
      </Slider>
    </Field>
  </template>
}
