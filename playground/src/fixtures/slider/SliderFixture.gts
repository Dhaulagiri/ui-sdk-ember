import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Field } from "ember-ui-sdk/field"
import { Slider } from "ember-ui-sdk/slider"
import {
  serialize,
  sliderFixture as f,
  sliderOptions,
} from "tests/fixtures/slider.ts"

type Value = number | number[]

export default class SliderFixture extends Component {
  f = f
  options = sliderOptions()
  @tracked action = ""
  @tracked commits: string[] = []
  @tracked submitted = ""
  @tracked volume: Value = this.options.volume

  get commitText() {
    return this.commits.join(" ")
  }

  get volumeValue() {
    return this.options.controlled ? this.volume : undefined
  }

  get volumeDefault() {
    return this.options.controlled ? undefined : this.options.volume
  }

  report(name: string, value: Value, details: { cancel: () => void }) {
    if (this.options.cancel === name) {
      return details.cancel()
    }
    this.action = `${name}:${String(value)}`
  }

  commit(name: string, value: Value) {
    this.commits = [...this.commits, `${name}:${String(value)}`]
  }

  onVolume = (
    value: Value,
    details: { cancel: () => void; canceled: boolean }
  ) => {
    this.report(f.volume.name, value, details)
    if (!details.canceled) {
      this.volume = value
    }
  }

  onPrice = (value: Value, details: { cancel: () => void }) => {
    this.report(f.price.name, value, details)
  }

  onVolumeCommit = (value: Value) => this.commit(f.volume.name, value)
  onPriceCommit = (value: Value) => this.commit(f.price.name, value)

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    this.submitted = serialize(event.currentTarget as HTMLFormElement)
  }

  <template>
    <div class="fixture">
      <button>Before</button>
      <form
        class="form"
        aria-label={{this.f.formLabel}}
        {{on "submit" this.onSubmit}}
      >
        <Field as |field|>
          <field.Label>{{this.f.volume.label}}</field.Label>
          <Slider
            @field={{field.field}}
            @orientation={{this.options.orientation}}
            @disabled={{this.options.disabled}}
            @largeStep={{this.options.largeStep}}
            @locale={{this.options.locale}}
            @name={{this.f.volume.name}}
            @format={{this.options.volumeFormat}}
            @value={{this.volumeValue}}
            @defaultValue={{this.volumeDefault}}
            @onValueChange={{this.onVolume}}
            @onValueCommit={{this.onVolumeCommit}}
            as |s|
          >
            <s.Value class="slider-value" />
            <s.Control class="slider-control">
              <s.Track class="slider-track">
                <s.Indicator class="slider-indicator" />
                <s.Thumb class="slider-thumb" />
              </s.Track>
            </s.Control>
          </Slider>
          <field.Description>{{this.f.volume.description}}</field.Description>
        </Field>

        <Field as |field|>
          <field.Label>{{this.f.price.label}}</field.Label>
          <Slider
            @field={{field.field}}
            @orientation={{this.options.orientation}}
            @disabled={{this.options.disabled}}
            @largeStep={{this.options.largeStep}}
            @locale={{this.options.locale}}
            @name={{this.f.price.name}}
            @defaultValue={{this.options.price}}
            @minStepsBetweenThumbs={{this.options.minSteps}}
            @format={{this.options.format}}
            @onValueChange={{this.onPrice}}
            @onValueCommit={{this.onPriceCommit}}
            as |s|
          >
            <s.Value class="slider-value" />
            <s.Control class="slider-control">
              <s.Track class="slider-track">
                <s.Indicator class="slider-indicator" />
                {{#each this.f.price.thumbs as |label index|}}
                  <s.Thumb
                    @index={{index}}
                    class="slider-thumb"
                    @ariaLabel={{label}}
                  />
                {{/each}}
              </s.Track>
            </s.Control>
          </Slider>
        </Field>

        <div class="row">
          <button type="submit">Save</button>
          <button type="reset">Reset</button>
        </div>
      </form>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
      <output role="status" aria-label="Committed">{{this.commitText}}</output>
      <output role="status" aria-label="Submitted">{{this.submitted}}</output>
    </div>
  </template>
}
