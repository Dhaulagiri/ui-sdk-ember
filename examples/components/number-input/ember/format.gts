import { Field } from "ember-ui-sdk/field"
import { NumberInput } from "ember-ui-sdk/number-input"
import { Minus, Plus } from "lucide"
import { icon } from "../../../shared/ember/icon"

const fields = [
  {
    label: "Price",
    defaultValue: 19.99,
    step: 0.01,
    format: { style: "currency" as const, currency: "USD" },
  },
  {
    label: "Discount",
    defaultValue: 0.15,
    step: 0.01,
    format: { style: "percent" as const },
  },
  {
    label: "Weight",
    defaultValue: 2.5,
    step: 0.1,
    format: { style: "unit" as const, unit: "kilogram" },
  },
]

<template>
  <div data-slot="stack">
    {{#each fields key="label" as |item|}}
      <Field as |f|>
        <f.Label>{{item.label}}</f.Label>
        <NumberInput
          @defaultValue={{item.defaultValue}}
          @step={{item.step}}
          @format={{item.format}}
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
    {{/each}}
  </div>
</template>
