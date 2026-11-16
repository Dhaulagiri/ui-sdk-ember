import { Field } from "ember-ui-sdk/field"
import { PasswordInput } from "ember-ui-sdk/password-input"
import { Eye, EyeOff, Lock } from "lucide"
import { icon } from "../../../shared/ember/icon"

<template>
  <Field @name="password" as |f|>
    <f.Label>Password</f.Label>
    <PasswordInput as |p|>
      <p.Control @field={{f.field}} />
      <span>{{#if p.state.capsLock}}{{icon Lock}}{{/if}}</span>
      <p.Toggle aria-label="Show password" as |t|>
        {{#if t.state.visible}}
          {{icon EyeOff}}
        {{else}}
          {{icon Eye}}
        {{/if}}
      </p.Toggle>
    </PasswordInput>
    <p data-slot="caps-lock">Caps Lock is on.</p>
  </Field>
</template>
