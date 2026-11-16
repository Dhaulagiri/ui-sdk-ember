import { Checkbox } from "ember-ui-sdk/checkbox"
import { Check } from "lucide"
import { icon } from "../../../shared/ember/icon"

<template>
  <label data-slot="label">
    <Checkbox as |c|>
      <c.Indicator>{{icon Check}}</c.Indicator>
    </Checkbox>
    Accept terms and conditions
  </label>
</template>
