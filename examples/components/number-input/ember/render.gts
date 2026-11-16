import Component from "@glimmer/component"
import { Field } from "ember-ui-sdk/field"
import { NumberInput } from "ember-ui-sdk/number-input"
import { Minus, Plus } from "lucide"
import { icon } from "../../../shared/ember/icon"

const celsius = { style: "unit", unit: "celsius" } as const

export default class Render extends Component {
  celsius = celsius

  <template>
    <Field as |f|>
      <f.Label>Temperature</f.Label>
      <NumberInput
        @defaultValue={{-2}}
        @min={{-20}}
        @max={{40}}
        @format={{this.celsius}}
        @field={{f.field}}
        as |n|
      >
        <n.Group>
          <n.Decrement @render={{true}} aria-label="Colder" as |d|>
            <button
              {{d.part}}
              title={{if d.state.atBound "As cold as it goes" "Colder"}}
              aria-label="Colder"
            >
              {{icon Minus}}
            </button>
          </n.Decrement>
          <n.Control />
          <n.Increment aria-label="Warmer" as |i|>
            {{#if i.state.atBound}}
              <span>Max</span>
            {{else}}
              {{icon Plus}}
            {{/if}}
          </n.Increment>
        </n.Group>
      </NumberInput>
    </Field>
  </template>
}
