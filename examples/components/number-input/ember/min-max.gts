import { Field } from "ember-ui-sdk/field"
import { NumberInput } from "ember-ui-sdk/number-input"
import { Minus, Plus } from "lucide"
import { icon } from "../../../shared/ember/icon"

<template>
  <Field as |f|>
    <f.Label>Guests</f.Label>
    <NumberInput
      @defaultValue={{2}}
      @min={{1}}
      @max={{8}}
      @field={{f.field}}
      as |n|
    >
      <n.Group>
        <n.Decrement aria-label="Decrease">{{icon Minus}}</n.Decrement>
        <n.Control />
        <n.Increment aria-label="Increase">{{icon Plus}}</n.Increment>
      </n.Group>
    </NumberInput>
    <f.Description>Tables seat between 1 and 8 guests.</f.Description>
  </Field>
</template>
