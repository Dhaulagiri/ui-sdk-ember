import { Field, FieldSet } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"

<template>
  <FieldSet dir="rtl" as |s|>
    <s.Legend>العنوان</s.Legend>
    <s.Description>نحتاج عنوانك لتوصيل طلبك.</s.Description>
    <Field @name="street" as |f|>
      <f.Label>الشارع</f.Label>
      <Input @field={{f.field}} />
    </Field>
    <Field @name="city" as |f|>
      <f.Label>المدينة</f.Label>
      <Input @field={{f.field}} />
    </Field>
  </FieldSet>
</template>
