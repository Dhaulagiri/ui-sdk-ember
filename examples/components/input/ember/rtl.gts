import { Field } from "ember-ui-sdk/field"
import { Input, InputGroup } from "ember-ui-sdk/input"
import { X } from "lucide"
import { icon } from "../../../shared/ember/icon"

<template>
  <div data-slot="stack" dir="rtl">
    <Field @name="name" as |f|>
      <f.Label>الاسم الكامل</f.Label>
      <Input placeholder="ليلى حسن" @field={{f.field}} />
      <f.Description>كما يظهر في ملفك الشخصي.</f.Description>
    </Field>
    <InputGroup as |g|>
      <Input type="search" aria-label="بحث" @defaultValue="حسن" />
      <g.Clear aria-label="مسح البحث">{{icon X}}</g.Clear>
    </InputGroup>
  </div>
</template>
