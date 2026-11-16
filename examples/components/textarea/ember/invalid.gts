import { Field } from "ember-ui-sdk/field"
import { Textarea } from "ember-ui-sdk/textarea"

<template>
  <Field @invalid={{true}} as |f|>
    <f.Label>Review</f.Label>
    <Textarea @defaultValue="Great." @field={{f.field}} />
    <f.Error @match={{true}}>Write at least 20 characters.</f.Error>
  </Field>
</template>
