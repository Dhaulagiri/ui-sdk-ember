import { Field, FieldGroup, FieldSet } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"

<template>
  <FieldSet as |s|>
    <s.Legend>Address</s.Legend>
    <s.Description>We need your address to deliver your order.</s.Description>
    <FieldGroup as |g|>
      <Field @name="street" as |f|>
        <f.Label>Street address</f.Label>
        <Input autocomplete="street-address" @field={{f.field}} />
      </Field>
      <div data-slot="grid">
        <Field @name="city" as |f|>
          <f.Label>City</f.Label>
          <Input autocomplete="address-level2" @field={{f.field}} />
        </Field>
        <Field @name="postal-code" as |f|>
          <f.Label>Postal code</f.Label>
          <Input autocomplete="postal-code" @field={{f.field}} />
        </Field>
      </div>
    </FieldGroup>
  </FieldSet>
</template>
