import { Field } from "ember-ui-sdk/field"
import { Textarea } from "ember-ui-sdk/textarea"

<template>
  <Field @name="feedback" as |f|>
    <f.Label>Feedback</f.Label>
    <Textarea placeholder="What could we do better?" @field={{f.field}} />
    <f.Description>Only the product team can see this.</f.Description>
  </Field>
</template>
