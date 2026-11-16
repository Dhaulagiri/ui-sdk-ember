import { OTPInput } from "ember-ui-sdk/otp-input"
import { Minus } from "lucide"
import { icon } from "../../../shared/ember/icon"

<template>
  <OTPInput @maxLength={{6}} aria-label="Verification code" as |o|>
    <o.Group>
      <o.Slot @index={{0}} />
      <o.Slot @index={{1}} />
    </o.Group>
    <o.Separator>{{icon Minus}}</o.Separator>
    <o.Group>
      <o.Slot @index={{2}} />
      <o.Slot @index={{3}} />
    </o.Group>
    <o.Separator>{{icon Minus}}</o.Separator>
    <o.Group>
      <o.Slot @index={{4}} />
      <o.Slot @index={{5}} />
    </o.Group>
  </OTPInput>
</template>
