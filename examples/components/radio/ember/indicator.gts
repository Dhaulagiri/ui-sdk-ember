import { Field } from "ember-ui-sdk/field"
import { RadioGroup } from "ember-ui-sdk/radio"

const themes = [
  { value: "light", label: "Light" },
  { value: "dark", label: "Dark" },
  { value: "system", label: "System" },
]

<template>
  <Field as |f|>
    <f.Label>Theme</f.Label>
    <RadioGroup @defaultValue="system" @field={{f.field}} as |g|>
      {{#each themes key="value" as |theme|}}
        <label data-slot="label">
          <g.Radio @value={{theme.value}} as |r|>
            <r.Indicator @keepMounted={{true}} />
          </g.Radio>
          {{theme.label}}
        </label>
      {{/each}}
    </RadioGroup>
  </Field>
</template>
