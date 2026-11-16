import { Field } from "ember-ui-sdk/field"
import { TimeInput } from "ember-ui-sdk/time-input"

<template>
  <Field as |f|>
    <f.Label>Meeting time</f.Label>
    <TimeInput @defaultValue="09:30" @field={{f.field}} />
  </Field>
</template>
