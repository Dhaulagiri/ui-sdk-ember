import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"
import { Checkbox } from "ember-ui-sdk/checkbox"
import { Check } from "lucide"
import { icon } from "../../../shared/ember/icon"

<template>
  <div data-slot="stack" dir="rtl">
    <Field as |f|>
      <f.Label>الاسم على البطاقة</f.Label>
      <Input
        name="card-name"
        autocomplete="cc-name"
        placeholder="ليلى حسن"
        @field={{f.field}}
      />
    </Field>
    <Field as |f|>
      <f.Label>رقم البطاقة</f.Label>
      <Input
        name="card-number"
        inputmode="numeric"
        autocomplete="cc-number"
        placeholder="1234 5678 9012 3456"
        @field={{f.field}}
      />
      <f.Description>أدخل الرقم المكون من 16 خانة.</f.Description>
    </Field>
    <Field as |f|>
      <Checkbox
        @name="save-card"
        @defaultChecked={{true}}
        @field={{f.field}}
        as |c|
      >
        <c.Indicator>{{icon Check}}</c.Indicator>
      </Checkbox>
      <f.Label>احفظ البطاقة للمدفوعات القادمة</f.Label>
    </Field>
  </div>
</template>
