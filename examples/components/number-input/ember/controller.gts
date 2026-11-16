import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Field } from "ember-ui-sdk/field"
import {
  NumberInput,
  createNumberInputController,
} from "ember-ui-sdk/number-input"
import { Minus, Plus } from "lucide"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const percent = { style: "unit", unit: "percent" } as const

export default class Controller extends Component {
  log = useLog(this)
  percent = percent
  zoom = createNumberInputController()

  zoomOut = () => this.zoom.decrement({ large: true })
  zoomIn = () => this.zoom.increment({ large: true })
  actualSize = () => this.zoom.setValue(100)
  read = () => this.log(`Zoom is ${this.zoom.getValue()}%`)
  focus = () => this.zoom.focus()

  onValueChange = (value: number | null, details: { reason: string }) => {
    this.log(`Zoom ${value ?? "empty"}% (${details.reason})`)
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.zoomOut}}>Zoom Out</button>
        <button type="button" {{on "click" this.zoomIn}}>Zoom In</button>
        <button type="button" {{on "click" this.actualSize}}>Actual Size</button>
        <button type="button" {{on "click" this.read}}>Read</button>
        <button type="button" {{on "click" this.focus}}>Focus</button>
      </div>
      <Field as |f|>
        <f.Label>Zoom</f.Label>
        <NumberInput
          @defaultValue={{100}}
          @min={{10}}
          @max={{400}}
          @step={{10}}
          @format={{this.percent}}
          @controller={{this.zoom}}
          @onValueChange={{this.onValueChange}}
          @field={{f.field}}
          as |n|
        >
          <n.Group>
            <n.Decrement aria-label="Decrease">{{icon Minus}}</n.Decrement>
            <n.Control />
            <n.Increment aria-label="Increase">{{icon Plus}}</n.Increment>
          </n.Group>
        </NumberInput>
      </Field>
    </div>
  </template>
}
