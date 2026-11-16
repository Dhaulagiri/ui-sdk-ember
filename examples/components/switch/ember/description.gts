import { Field } from "ember-ui-sdk/field"
import { Switch } from "ember-ui-sdk/switch"

<template>
  <Field as |f|>
    <div data-slot="stack">
      <f.Label>Weekly digest</f.Label>
      <f.Description>A summary of your week, every Monday.</f.Description>
    </div>
    <Switch @field={{f.field}} as |s|>
      <s.Thumb />
    </Switch>
  </Field>
</template>
