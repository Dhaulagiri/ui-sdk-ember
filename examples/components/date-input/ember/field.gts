import { DateInput } from "ember-ui-sdk/date-input"
import { Field } from "ember-ui-sdk/field"

<template>
  <Field as |f|>
    <f.Label>Birthday</f.Label>
    <DateInput @name="birthday" @field={{f.field}} />
    <f.Description>We send a card on the day.</f.Description>
  </Field>
</template>
