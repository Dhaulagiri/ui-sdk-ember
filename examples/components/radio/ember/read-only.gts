import { Field } from "ember-ui-sdk/field"
import { RadioGroup } from "ember-ui-sdk/radio"

const plans = [
  { value: "free", label: "Free" },
  { value: "pro", label: "Pro" },
  { value: "team", label: "Team" },
]

<template>
  <Field as |f|>
    <f.Label>Your plan</f.Label>
    <f.Description>Ask an admin to change plans.</f.Description>
    <RadioGroup
      @defaultValue="pro"
      @readOnly={{true}}
      @field={{f.field}}
      as |g|
    >
      {{#each plans key="value" as |plan|}}
        <label data-slot="label">
          <g.Radio @value={{plan.value}} as |r|>
            <r.Indicator />
          </g.Radio>
          {{plan.label}}
        </label>
      {{/each}}
    </RadioGroup>
  </Field>
</template>
