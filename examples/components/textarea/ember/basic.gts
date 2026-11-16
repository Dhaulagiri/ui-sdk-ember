import { Field } from "ember-ui-sdk/field"
import { Textarea } from "ember-ui-sdk/textarea"

<template>
  <Field @name="message" as |f|>
    <f.Label>Message</f.Label>
    <Textarea placeholder="Type your message here…" @field={{f.field}} />
  </Field>
</template>
