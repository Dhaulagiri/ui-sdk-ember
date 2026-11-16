import { DateInput } from "ember-ui-sdk/date-input"
import { Field } from "ember-ui-sdk/field"

<template>
  <Field as |f|>
    <f.Label>Start date</f.Label>
    <DateInput @field={{f.field}} />
  </Field>
</template>
