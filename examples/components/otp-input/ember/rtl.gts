import { Field } from "ember-ui-sdk/field"
import { OTPInput } from "ember-ui-sdk/otp-input"

<template>
  <Field dir="rtl" as |f|>
    <f.Label>رمز التحقق</f.Label>
    <OTPInput @maxLength={{6}} @field={{f.field}} as |o|>
      <o.Group>
        <o.Slot @index={{0}} />
        <o.Slot @index={{1}} />
        <o.Slot @index={{2}} />
        <o.Slot @index={{3}} />
        <o.Slot @index={{4}} />
        <o.Slot @index={{5}} />
      </o.Group>
    </OTPInput>
  </Field>
</template>
