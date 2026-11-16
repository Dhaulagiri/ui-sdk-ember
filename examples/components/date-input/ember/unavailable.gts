import { DateInput } from "ember-ui-sdk/date-input"
import { Field } from "ember-ui-sdk/field"

const unavailable = { weekday: [0, 6] }

<template>
  <Field as |f|>
    <f.Label>Delivery date</f.Label>
    <DateInput
      @defaultValue="2026-11-02"
      @unavailable={{unavailable}}
      @field={{f.field}}
    />
    <f.Description>We deliver Monday to Friday.</f.Description>
    <f.Error />
  </Field>
</template>
