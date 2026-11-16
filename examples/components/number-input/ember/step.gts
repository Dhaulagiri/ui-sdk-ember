import { Field } from "ember-ui-sdk/field"
import { NumberInput } from "ember-ui-sdk/number-input"
import { Minus, Plus } from "lucide"
import { icon } from "../../../shared/ember/icon"

<template>
  <Field as |f|>
    <f.Label>Hours</f.Label>
    <NumberInput
      @defaultValue={{1.5}}
      @min={{0}}
      @max={{24}}
      @step={{0.25}}
      @largeStep={{1}}
      @smallStep={{0.05}}
      @field={{f.field}}
      as |n|
    >
      <n.Group>
        <n.Decrement aria-label="Decrease">{{icon Minus}}</n.Decrement>
        <n.Control />
        <n.Increment aria-label="Increase">{{icon Plus}}</n.Increment>
      </n.Group>
    </NumberInput>
    <f.Description>Logged in quarter hours.</f.Description>
  </Field>
</template>
