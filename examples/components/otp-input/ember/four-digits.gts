import { Field } from "ember-ui-sdk/field"
import { OTPInput } from "ember-ui-sdk/otp-input"

<template>
  <Field as |f|>
    <f.Label>PIN</f.Label>
    <OTPInput @maxLength={{4}} @textAlign="center" @field={{f.field}} as |o|>
      <o.Group>
        <o.Slot @index={{0}} />
        <o.Slot @index={{1}} />
        <o.Slot @index={{2}} />
        <o.Slot @index={{3}} />
      </o.Group>
    </OTPInput>
  </Field>
</template>
