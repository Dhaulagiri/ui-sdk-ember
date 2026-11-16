import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Field } from "ember-ui-sdk/field"
import { Slider, createSliderController } from "ember-ui-sdk/slider"
import { useLog } from "../../../shared/ember/log"

export default class Controller extends Component {
  log = useLog(this)
  volume = createSliderController<number>()

  mute = () => this.volume.setValue(0)
  louder = () => this.volume.setValue(this.volume.getValue() + 10)
  read = () => this.log(`Volume is ${this.volume.getValue()}`)
  focus = () => this.volume.focus()

  onValueChange = (value: number | number[], details: { reason: string }) => {
    this.log(`Volume ${value} (${details.reason})`)
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.mute}}>Mute</button>
        <button type="button" {{on "click" this.louder}}>Louder</button>
        <button type="button" {{on "click" this.read}}>Read</button>
        <button type="button" {{on "click" this.focus}}>Focus</button>
      </div>
      <Field as |f|>
        <Slider
          @defaultValue={{40}}
          @controller={{this.volume}}
          @onValueChange={{this.onValueChange}}
          @field={{f.field}}
          as |s|
        >
          <div data-slot="row">
            <f.Label>Volume</f.Label>
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
    </div>
  </template>
}
