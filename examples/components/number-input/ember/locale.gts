import { Field } from "ember-ui-sdk/field"
import { NumberInput } from "ember-ui-sdk/number-input"
import { Minus, Plus } from "lucide"
import { icon } from "../../../shared/ember/icon"

const fields = [
  {
    label: "Preis",
    locale: "de-DE",
    defaultValue: 1234.5,
    step: 0.01,
    format: { style: "currency" as const, currency: "EUR" },
  },
  {
    label: "Budget",
    locale: "en-IN",
    defaultValue: 1234567,
    step: 1000,
    format: {
      style: "currency" as const,
      currency: "INR",
      maximumFractionDigits: 0,
    },
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
          @locale={{item.locale}}
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
        <f.Description>Formatted for {{item.locale}}.</f.Description>
      </Field>
    {{/each}}
  </div>
</template>
