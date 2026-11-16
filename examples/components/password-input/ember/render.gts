import { Field } from "ember-ui-sdk/field"
import { PasswordInput } from "ember-ui-sdk/password-input"
import { Eye, EyeOff } from "lucide"
import { icon } from "../../../shared/ember/icon"

<template>
  <Field @name="password" as |f|>
    <f.Label>Password</f.Label>
    <PasswordInput as |p|>
      <p.Control @field={{f.field}} />
      <p.Toggle @render={{true}} aria-label="Show password" as |t|>
        <button {{t.part}}>
          {{#if t.state.visible}}
            {{icon EyeOff}}
          {{else}}
            {{icon Eye}}
          {{/if}}
        </button>
      </p.Toggle>
    </PasswordInput>
  </Field>
</template>
