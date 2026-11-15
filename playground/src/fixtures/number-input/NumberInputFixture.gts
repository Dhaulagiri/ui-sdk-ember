import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Field } from "ember-ui-sdk/field"
import { NumberInput } from "ember-ui-sdk/number-input"
import {
  numberInputFixture as f,
  numberInputOptions,
  serialize,
} from "tests/fixtures/number-input.ts"

type Details = { cancel: () => void; canceled: boolean }

const currency = { style: "currency" as const, currency: f.amount.currency }

export default class NumberInputFixture extends Component {
  f = f
  options = numberInputOptions()
  currency = currency
  @tracked action = ""
  @tracked commits: string[] = []
  @tracked submitted = ""
  @tracked quantity: number | null = this.options.quantity

  get committed() {
    return this.commits.join(" ")
  }

  report = (name: string, value: number | null, details: Details) => {
    if (this.options.cancel === name) {
      return details.cancel()
    }
    this.action = `${name}:${String(value)}`
  }

  onQuantity = (value: number | null, details: Details) => {
    this.report(f.quantity.name, value, details)
    if (!details.canceled) {
      this.quantity = value ?? null
    }
  }

  commit = (name: string, value: number | null) => {
    this.commits = [...this.commits, `${name}:${String(value)}`]
  }

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
        <Field @name={{this.f.quantity.name}} as |field|>
          <field.Label>{{this.f.quantity.label}}</field.Label>
          <NumberInput
            @field={{field.field}}
            @wheel={{this.options.wheel}}
            @disabled={{this.options.disabled}}
            @readOnly={{this.options.readOnly}}
            @locale={{this.options.locale}}
            @min={{this.f.quantity.min}}
            @max={{this.f.quantity.max}}
            @required={{this.options.required}}
            @value={{if this.options.controlled this.quantity}}
            @defaultValue={{if
              this.options.controlled
              undefined
              this.options.quantity
            }}
            @onValueChange={{this.onQuantity}}
            @onValueCommit={{fn this.commit this.f.quantity.name}}
            as |n|
          >
            <n.Group class="number-input-group">
              <n.Decrement
                aria-label={{this.f.quantity.decrement}}
              >−</n.Decrement>
              <n.Control class="number-input-control" />
              <n.Increment
                aria-label={{this.f.quantity.increment}}
                @disabled={{this.options.disabledIncrement}}
              >+</n.Increment>
            </n.Group>
          </NumberInput>
          <field.Description>{{this.f.quantity.description}}</field.Description>
        </Field>

        <Field as |field|>
          <field.Label>{{this.f.amount.label}}</field.Label>
          <NumberInput
            @field={{field.field}}
            @wheel={{this.options.wheel}}
            @disabled={{this.options.disabled}}
            @readOnly={{this.options.readOnly}}
            @locale={{this.options.locale}}
            @name={{this.f.amount.name}}
            @defaultValue={{this.f.amount.defaultValue}}
            @min={{this.options.amountMin}}
            @step={{this.f.amount.step}}
            @format={{this.currency}}
            @onValueChange={{fn this.report this.f.amount.name}}
            @onValueCommit={{fn this.commit this.f.amount.name}}
            as |n|
          >
            <n.ScrubArea
              class="number-input-scrub"
            >{{this.f.amount.scrub}}</n.ScrubArea>
            <n.Group class="number-input-group">
              <n.Decrement
                aria-label={{this.f.amount.decrement}}
              >−</n.Decrement>
              <n.Control class="number-input-control" />
              <n.Increment
                aria-label={{this.f.amount.increment}}
              >+</n.Increment>
            </n.Group>
          </NumberInput>
        </Field>

        <div class="row">
          <button type="submit">Save</button>
          <button type="reset">Reset</button>
        </div>
      </form>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
      <output role="status" aria-label="Committed">{{this.committed}}</output>
      <output role="status" aria-label="Submitted">{{this.submitted}}</output>
    </div>
  </template>
}
