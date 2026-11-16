import Component from "@glimmer/component"
import { Field } from "ember-ui-sdk/field"
import { NumberInput } from "ember-ui-sdk/number-input"
import { Minus, MoveHorizontal, Plus } from "lucide"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

export default class Basic extends Component {
  log = useLog(this)

  onValueCommit = (value: number | null) => {
    this.log(`Quantity ${value ?? "empty"}`)
  }

  <template>
    <Field as |f|>
      <NumberInput
        @defaultValue={{1}}
        @min={{1}}
        @field={{f.field}}
        @onValueCommit={{this.onValueCommit}}
        as |n|
      >
        <n.ScrubArea @pixelsPerStep={{4}}>
          <f.Label>Quantity</f.Label>
          <n.ScrubAreaCursor>{{icon MoveHorizontal}}</n.ScrubAreaCursor>
        </n.ScrubArea>
        <n.Group>
          <n.Decrement aria-label="Decrease">{{icon Minus}}</n.Decrement>
          <n.Control />
          <n.Increment aria-label="Increase">{{icon Plus}}</n.Increment>
        </n.Group>
      </NumberInput>
    </Field>
  </template>
}
