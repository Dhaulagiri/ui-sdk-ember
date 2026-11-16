import { Field } from "ember-ui-sdk/field"
import { Textarea } from "ember-ui-sdk/textarea"

<template>
  <Field @name="notes" as |f|>
    <f.Label>Notes</f.Label>
    <Textarea
      @autoResize={{true}}
      placeholder="Add notes for the delivery driver…"
      @field={{f.field}}
    />
    <f.Description>Your driver sees these notes.</f.Description>
  </Field>
</template>
