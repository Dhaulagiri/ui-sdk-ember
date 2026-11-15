import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { NumberInput } from "ember-ui-sdk/number-input"
import { Slider } from "ember-ui-sdk/slider"

export default class Fixture extends Component {
  @tracked action = ""

  onValueChange = (value: number | number[]) => {
    this.action = `brightness:${value}`
  }

  <template>
    <div class="fixture">
      <button>Before</button>
      <Slider @defaultValue={{40}} @onValueChange={{this.onValueChange}} as |s|>
        <s.Value class="slider-value" as |value|>Brightness
          {{value.state.text}}</s.Value>
        <s.Control class="slider-control">
          <s.Track class="slider-track">
            <s.Indicator class="slider-indicator" />
            <s.Thumb
              class="slider-thumb"
              @ariaLabel="Brightness"
              @render={{true}}
              as |thumb|
            >
              <span {{thumb.part}}>
                <span class="thumb-label">{{thumb.state.thumbValue}}</span>
                <thumb.Input />
              </span>
            </s.Thumb>
          </s.Track>
        </s.Control>
      </Slider>
      <NumberInput @defaultValue={{8}} @max={{9}} as |n|>
        <n.Control aria-label="Count" />
        <n.Increment aria-label="Increase count" as |inc|>{{if
            inc.state.disabled
            "At most"
            "More"
          }}</n.Increment>
      </NumberInput>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
    </div>
  </template>
}
