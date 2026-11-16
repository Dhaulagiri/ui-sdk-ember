import { Field } from "ember-ui-sdk/field"
import { OTPInput } from "ember-ui-sdk/otp-input"
import { Minus } from "lucide"
import { icon } from "../../../shared/ember/icon"

<template>
  <Field as |f|>
    <f.Label>Verification code</f.Label>
    <OTPInput @maxLength={{6}} @field={{f.field}} as |o|>
      <o.Group>
        <o.Slot @index={{0}} />
        <o.Slot @index={{1}} />
        <o.Slot @index={{2}} />
      </o.Group>
      <o.Separator>{{icon Minus}}</o.Separator>
      <o.Group>
        <o.Slot @index={{3}} />
        <o.Slot @index={{4}} />
        <o.Slot @index={{5}} />
      </o.Group>
    </OTPInput>
  </Field>
</template>
