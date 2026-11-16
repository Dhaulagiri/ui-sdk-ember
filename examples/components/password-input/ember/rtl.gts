import { Field } from "ember-ui-sdk/field"
import { PasswordInput } from "ember-ui-sdk/password-input"
import { Eye, EyeOff } from "lucide"
import { icon } from "../../../shared/ember/icon"

<template>
  <div dir="rtl">
    <Field @name="password" as |f|>
      <f.Label>كلمة المرور</f.Label>
      <PasswordInput as |p|>
        <p.Control @field={{f.field}} />
        <p.Toggle aria-label="إظهار كلمة المرور" as |t|>
          {{#if t.state.visible}}
            {{icon EyeOff}}
          {{else}}
            {{icon Eye}}
          {{/if}}
        </p.Toggle>
      </PasswordInput>
      <f.Description>ثمانية أحرف على الأقل.</f.Description>
    </Field>
  </div>
</template>
