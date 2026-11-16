import { Field } from "ember-ui-sdk/field"
import { Textarea } from "ember-ui-sdk/textarea"

<template>
  <Field @disabled={{true}} as |f|>
    <f.Label>Reply</f.Label>
    <Textarea
      @defaultValue="Replies are closed for this thread."
      @field={{f.field}}
    />
  </Field>
</template>
