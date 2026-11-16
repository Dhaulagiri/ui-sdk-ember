import { Field } from "ember-ui-sdk/field"
import { TimeInput } from "ember-ui-sdk/time-input"

<template>
  <div data-slot="stack">
    <Field as |f|>
      <f.Label>12-hour clock</f.Label>
      <TimeInput @hourCycle={{12}} @defaultValue="18:45" @field={{f.field}} />
    </Field>
    <Field as |f|>
      <f.Label>24-hour clock</f.Label>
      <TimeInput @hourCycle={{24}} @defaultValue="18:45" @field={{f.field}} />
    </Field>
    <Field as |f|>
      <f.Label>With seconds</f.Label>
      <TimeInput
        @granularity="second"
        @hourCycle={{24}}
        @defaultValue="18:45:30"
        @field={{f.field}}
      />
    </Field>
  </div>
</template>
