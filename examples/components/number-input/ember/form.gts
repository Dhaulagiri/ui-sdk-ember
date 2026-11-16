import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Field } from "ember-ui-sdk/field"
import { NumberInput } from "ember-ui-sdk/number-input"
import { Minus, Plus } from "lucide"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const usd = { style: "currency", currency: "USD" } as const

export default class Form extends Component {
  log = useLog(this)
  usd = usd

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    const data = [...new FormData(event.currentTarget as HTMLFormElement)].map(
      ([name, value]) => `${name}=${value}`
    )
    this.log(`Submitted ${data.join(", ")}`)
  }

  <template>
    <div data-slot="stack">
      <form data-slot="stack" id="number-form" {{on "submit" this.onSubmit}}>
        <Field as |f|>
          <f.Label>Quantity</f.Label>
          <NumberInput
            @name="quantity"
            @defaultValue={{2}}
            @min={{1}}
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
        <Field as |f|>
          <f.Label>Tip</f.Label>
          <NumberInput
            @name="tip"
            @defaultValue={{4.5}}
            @min={{0}}
            @step={{0.5}}
            @format={{this.usd}}
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
      </form>
      <Field as |f|>
        <f.Label>Gift cards</f.Label>
        <NumberInput
          @name="gift-cards"
          @form="number-form"
          @defaultValue={{0}}
          @min={{0}}
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
      <div data-slot="row">
        <button type="reset" form="number-form">Reset</button>
        <button
          type="submit"
          form="number-form"
          data-variant="solid"
        >Save</button>
      </div>
    </div>
  </template>
}
