import { Checkbox } from "ember-ui-sdk/checkbox"
import { Field } from "ember-ui-sdk/field"
import { Check } from "lucide"
import { icon } from "../../../shared/ember/icon"

<template>
  <Field as |f|>
    <Checkbox @field={{f.field}} as |c|>
      <c.Indicator>{{icon Check}}</c.Indicator>
    </Checkbox>
    <div data-slot="stack">
      <f.Label>Accept terms and conditions</f.Label>
      <f.Description>
        By clicking this checkbox, you agree to the terms and conditions.
      </f.Description>
    </div>
  </Field>
</template>
