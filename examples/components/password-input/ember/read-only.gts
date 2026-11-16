import { Field } from "ember-ui-sdk/field"
import { PasswordInput } from "ember-ui-sdk/password-input"
import { Eye, EyeOff } from "lucide"
import { icon } from "../../../shared/ember/icon"

<template>
  <Field @name="recovery-key" as |f|>
    <f.Label>Recovery key</f.Label>
    <PasswordInput
      @readOnly={{true}}
      @defaultValue="7Hq2-vX9p-Lm4c"
      @autoComplete="off"
      as |p|
    >
      <p.Control @field={{f.field}} />
      <p.Toggle aria-label="Show recovery key" as |t|>
        {{#if t.state.visible}}
          {{icon EyeOff}}
        {{else}}
          {{icon Eye}}
        {{/if}}
      </p.Toggle>
    </PasswordInput>
    <f.Description>Keep it somewhere safe. You can show it, but not change it.</f.Description>
  </Field>
</template>
