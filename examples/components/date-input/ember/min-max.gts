import { DateInput } from "ember-ui-sdk/date-input"
import { Field } from "ember-ui-sdk/field"

<template>
  <Field as |f|>
    <f.Label>Check-in</f.Label>
    <DateInput
      @min="2026-01-01"
      @max="2026-12-31"
      @defaultValue="2026-06-15"
      @field={{f.field}}
    />
    <f.Description>Any day in 2026.</f.Description>
    <f.Error />
  </Field>
</template>
