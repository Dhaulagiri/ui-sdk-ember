import { Field } from "ember-ui-sdk/field"
import { Textarea } from "ember-ui-sdk/textarea"

<template>
  <Field dir="rtl" @name="feedback" as |f|>
    <f.Label>ملاحظاتك</f.Label>
    <Textarea
      @autoResize={{true}}
      placeholder="أخبرنا برأيك…"
      @field={{f.field}}
    />
    <f.Description>نقرأ كل رسالة.</f.Description>
  </Field>
</template>
