import { Field } from "ember-ui-sdk/field"
import { RadioGroup } from "ember-ui-sdk/radio"

const plans = [
  {
    value: "hobby",
    label: "Hobby",
    description: "Free for personal projects.",
  },
  {
    value: "pro",
    label: "Pro",
    description: "$20 per month for growing teams.",
  },
  {
    value: "enterprise",
    label: "Enterprise",
    description: "Custom pricing and support.",
  },
]

<template>
  <Field as |f|>
    <f.Label>Plan</f.Label>
    <RadioGroup @defaultValue="hobby" @field={{f.field}} as |g|>
      {{#each plans key="value" as |plan|}}
        <label data-slot="card">
          <span data-slot="stack">
            <span>{{plan.label}}</span>
            <span data-slot="hint">{{plan.description}}</span>
          </span>
          <g.Radio @value={{plan.value}} as |r|>
            <r.Indicator />
          </g.Radio>
        </label>
      {{/each}}
    </RadioGroup>
  </Field>
</template>
