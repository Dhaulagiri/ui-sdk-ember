import { Field } from "ember-ui-sdk/field"
import { NumberInput } from "ember-ui-sdk/number-input"
import { Minus, Plus } from "lucide"
import { icon } from "../../../shared/ember/icon"

<template>
  <Field as |f|>
    <f.Label>Tickets</f.Label>
    <NumberInput @defaultValue={{2}} @min={{1}} @field={{f.field}} as |n|>
      <n.Group>
        <n.Decrement aria-label="Decrease">{{icon Minus}}</n.Decrement>
        <n.Control />
        <n.Increment aria-label="Increase">{{icon Plus}}</n.Increment>
      </n.Group>
    </NumberInput>
    <f.Description>Each ticket admits one person to the workshop.</f.Description>
  </Field>
</template>
