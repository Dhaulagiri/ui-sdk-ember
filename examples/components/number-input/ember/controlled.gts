import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { tracked } from "@glimmer/tracking"
import { Field } from "ember-ui-sdk/field"
import { NumberInput } from "ember-ui-sdk/number-input"
import { Minus, Plus } from "lucide"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

export default class Controlled extends Component {
  log = useLog(this)
  @tracked value: number | null = 4

  reset = () => {
    this.value = 4
  }

  clear = () => {
    this.value = null
  }

  onValueChange = (next: number | null, details: { reason: string }) => {
    this.value = next
    this.log(`Value ${next ?? "empty"} (${details.reason})`)
  }

  onValueCommit = (next: number | null, details: { reason: string }) => {
    this.log(`Committed ${next ?? "empty"} (${details.reason})`)
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.reset}}>Reset to 4</button>
        <button type="button" {{on "click" this.clear}}>Clear</button>
      </div>
      <Field as |f|>
        <f.Label>Servings</f.Label>
        <NumberInput
          @value={{this.value}}
          @onValueChange={{this.onValueChange}}
          @onValueCommit={{this.onValueCommit}}
          @min={{1}}
          @max={{12}}
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
