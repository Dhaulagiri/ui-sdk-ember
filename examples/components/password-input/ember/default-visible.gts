import { Field } from "ember-ui-sdk/field"
import { PasswordInput } from "ember-ui-sdk/password-input"
import { Eye, EyeOff } from "lucide"
import { icon } from "../../../shared/ember/icon"

<template>
  <Field @name="wifi-password" as |f|>
    <f.Label>Wi-Fi password</f.Label>
    <PasswordInput
      @defaultVisible={{true}}
      @defaultValue="maple-orbit-42"
      @autoComplete="new-password"
      as |p|
    >
      <p.Control @field={{f.field}} />
      <p.Toggle aria-label="Show password" as |t|>
        {{#if t.state.visible}}
          {{icon EyeOff}}
        {{else}}
          {{icon Eye}}
        {{/if}}
      </p.Toggle>
    </PasswordInput>
    <f.Description>Guests read it from here, so it starts shown.</f.Description>
  </Field>
</template>
