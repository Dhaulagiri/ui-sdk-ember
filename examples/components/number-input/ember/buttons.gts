import { NumberInput } from "ember-ui-sdk/number-input"
import { Minus, Plus } from "lucide"
import { icon } from "../../../shared/ember/icon"

<template>
  <NumberInput @defaultValue={{1}} @min={{0}} as |n|>
    <n.Group>
      <n.Decrement aria-label="Decrease">{{icon Minus}}</n.Decrement>
      <n.Control aria-label="Quantity" />
      <n.Increment aria-label="Increase">{{icon Plus}}</n.Increment>
    </n.Group>
  </NumberInput>
</template>
