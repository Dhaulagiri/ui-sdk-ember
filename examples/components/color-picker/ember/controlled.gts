import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import {
  ColorPicker,
  createColorPickerController,
} from "ember-ui-sdk/color-picker"
import { useLog } from "../../../shared/ember/log"

export default class Controlled extends Component {
  log = useLog(this)
  picker = createColorPickerController()
  @tracked value = "#0ea5e9"

  onValueChange = (next: string) => {
    this.value = next
  }

  onValueCommit = (next: string, details: { reason: string }) => {
    this.log(`committed: ${next} (${details.reason})`)
  }

  usePurple = () => {
    this.picker.setValue("#663399")
  }

  <template>
    <div>
      <div data-slot="controls">
        <button type="button" {{on "click" this.usePurple}}>Use Purple</button>
      </div>
      <ColorPicker
        aria-label="Theme color"
        @value={{this.value}}
        @onValueChange={{this.onValueChange}}
        @onValueCommit={{this.onValueCommit}}
        @controller={{this.picker}}
        as |c|
      >
        <c.Area as |a|>
          <a.Thumb />
        </c.Area>
        <c.Slider @channel="hue" as |s|>
          <s.Thumb />
        </c.Slider>
        <c.Input aria-label="Hex" />
      </ColorPicker>
    </div>
  </template>
}
