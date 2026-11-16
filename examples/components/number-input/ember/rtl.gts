import { Field } from "ember-ui-sdk/field"
import { NumberInput } from "ember-ui-sdk/number-input"
import { Minus, Plus } from "lucide"
import { icon } from "../../../shared/ember/icon"

<template>
  <div dir="rtl">
    <Field as |f|>
      <f.Label>الكمية</f.Label>
      <NumberInput @defaultValue={{1}} @min={{0}} @field={{f.field}} as |n|>
        <n.Group>
          <n.Decrement aria-label="إنقاص">{{icon Minus}}</n.Decrement>
          <n.Control />
          <n.Increment aria-label="زيادة">{{icon Plus}}</n.Increment>
        </n.Group>
      </NumberInput>
    </Field>
  </div>
</template>
