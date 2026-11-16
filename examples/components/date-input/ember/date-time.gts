import { DateInput } from "ember-ui-sdk/date-input"
import { Field } from "ember-ui-sdk/field"

<template>
  <Field as |f|>
    <f.Label>Departure</f.Label>
    <DateInput
      @granularity="minute"
      @defaultValue="2026-11-02T14:30"
      @field={{f.field}}
    />
  </Field>
</template>
