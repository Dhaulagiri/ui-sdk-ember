import { Field } from "ember-ui-sdk/field"
import { Switch } from "ember-ui-sdk/switch"

<template>
  <Field as |f|>
    <div data-slot="stack">
      <f.Label>Encrypt backups</f.Label>
      <f.Description>Your organization manages this setting.</f.Description>
    </div>
    <Switch
      @name="encrypt"
      @defaultChecked={{true}}
      @readOnly={{true}}
      @field={{f.field}}
      as |s|
    >
      <s.Thumb />
    </Switch>
  </Field>
</template>
