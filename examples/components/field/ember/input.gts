import { Field, FieldDescription } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"

<template>
  <div data-slot="stack">
    <Field as |f|>
      <f.Label>Username</f.Label>
      <Input
        name="username"
        placeholder="hollis"
        autocomplete="username"
        @field={{f.field}}
      />
      <f.Description>Choose a unique username for your account.</f.Description>
    </Field>
  </div>
</template>
