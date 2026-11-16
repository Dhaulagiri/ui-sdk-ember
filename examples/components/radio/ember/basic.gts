import { Field } from "ember-ui-sdk/field"
import { RadioGroup } from "ember-ui-sdk/radio"

const speeds = [
  { value: "standard", label: "Standard" },
  { value: "express", label: "Express" },
  { value: "overnight", label: "Overnight" },
]

<template>
  <Field as |f|>
    <f.Label>Shipping speed</f.Label>
    <RadioGroup @defaultValue="standard" @field={{f.field}} as |g|>
      {{#each speeds key="value" as |speed|}}
        <label data-slot="label">
          <g.Radio @value={{speed.value}} as |r|>
            <r.Indicator />
          </g.Radio>
          {{speed.label}}
        </label>
      {{/each}}
    </RadioGroup>
  </Field>
</template>
