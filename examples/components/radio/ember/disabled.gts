import { Field } from "ember-ui-sdk/field"
import { RadioGroup } from "ember-ui-sdk/radio"

const themes = [
  { value: "light", label: "Light" },
  { value: "dark", label: "Dark" },
  { value: "system", label: "System" },
]

const backups = [
  { value: "hourly", label: "Hourly", disabled: true },
  { value: "daily", label: "Daily", disabled: false },
  { value: "weekly", label: "Weekly", disabled: false },
]

<template>
  <div data-slot="stack">
    <Field as |f|>
      <f.Label>Theme</f.Label>
      <f.Description>Set by your organization.</f.Description>
      <RadioGroup
        @defaultValue="light"
        @disabled={{true}}
        @field={{f.field}}
        as |g|
      >
        {{#each themes key="value" as |theme|}}
          <label data-slot="label">
            <g.Radio @value={{theme.value}} as |r|>
              <r.Indicator />
            </g.Radio>
            {{theme.label}}
          </label>
        {{/each}}
      </RadioGroup>
    </Field>
    <Field as |f|>
      <f.Label>Backups</f.Label>
      <f.Description>Hourly backups need the Pro plan.</f.Description>
      <RadioGroup @defaultValue="daily" @field={{f.field}} as |g|>
        {{#each backups key="value" as |backup|}}
          <label data-slot="label">
            <g.Radio
              @value={{backup.value}}
              @disabled={{backup.disabled}}
              as |r|
            >
              <r.Indicator />
            </g.Radio>
            {{backup.label}}
          </label>
        {{/each}}
      </RadioGroup>
    </Field>
  </div>
</template>
