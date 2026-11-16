import { Checkbox } from "ember-ui-sdk/checkbox"
import { Label } from "ember-ui-sdk/label"
import { Check } from "lucide"
import { icon } from "../../../shared/ember/icon"

<template>
  <Label>
    <Checkbox as |c|>
      <c.Indicator>{{icon Check}}</c.Indicator>
    </Checkbox>
    Accept terms and conditions
  </Label>
</template>
