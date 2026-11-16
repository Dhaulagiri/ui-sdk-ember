import { Field } from "ember-ui-sdk/field"
import { RadioGroup } from "ember-ui-sdk/radio"

const frequencies = [
  { value: "instant", label: "Instantly", description: "An email right away." },
  {
    value: "daily",
    label: "Daily digest",
    description: "One email each morning.",
  },
  {
    value: "weekly",
    label: "Weekly digest",
    description: "A summary every Monday.",
  },
]

<template>
  <Field as |f|>
    <f.Label>Email notifications</f.Label>
    <RadioGroup @defaultValue="daily" @field={{f.field}} as |g|>
      {{#each frequencies key="value" as |frequency|}}
        <Field as |inner|>
          <g.Radio @value={{frequency.value}} @field={{inner.field}} as |r|>
            <r.Indicator />
          </g.Radio>
          <div data-slot="stack">
            <inner.Label>{{frequency.label}}</inner.Label>
            <inner.Description>{{frequency.description}}</inner.Description>
          </div>
        </Field>
      {{/each}}
    </RadioGroup>
  </Field>
</template>
