import { DateInput } from "ember-ui-sdk/date-input"
import { Field } from "ember-ui-sdk/field"

<template>
  <Field as |f|>
    <f.Label>Signed on</f.Label>
    <DateInput
      @defaultValue="2026-11-02"
      @readOnly={{true}}
      @field={{f.field}}
    />
  </Field>
</template>
