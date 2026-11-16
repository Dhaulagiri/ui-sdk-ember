import { Checkbox } from "ember-ui-sdk/checkbox"
import { Field } from "ember-ui-sdk/field"
import { Check } from "lucide"
import { icon } from "../../../shared/ember/icon"

<template>
  <Field as |f|>
    <Checkbox
      @name="two-factor"
      @defaultChecked={{true}}
      @readOnly={{true}}
      @field={{f.field}}
      as |c|
    >
      <c.Indicator>{{icon Check}}</c.Indicator>
    </Checkbox>
    <div data-slot="stack">
      <f.Label>Require two-factor authentication</f.Label>
      <f.Description>Your organization requires this setting.</f.Description>
    </div>
  </Field>
</template>
