import { Field } from "ember-ui-sdk/field"
import { NumberInput } from "ember-ui-sdk/number-input"
import { Minus, Plus } from "lucide"
import { icon } from "../../../shared/ember/icon"

<template>
  <Field as |f|>
    <f.Label>Font size</f.Label>
    <NumberInput
      @defaultValue={{16}}
      @min={{8}}
      @max={{72}}
      @wheel={{true}}
      @field={{f.field}}
      as |n|
    >
      <n.Group>
        <n.Decrement aria-label="Decrease">{{icon Minus}}</n.Decrement>
        <n.Control />
        <n.Increment aria-label="Increase">{{icon Plus}}</n.Increment>
      </n.Group>
    </NumberInput>
    <f.Description>Focus the input, then scroll over it.</f.Description>
  </Field>
</template>
