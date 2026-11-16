import { Autocomplete } from "ember-ui-sdk/autocomplete"
import { ChevronDown, X } from "lucide"
import { icon } from "../../../shared/ember/icon"

const fruits = [
  "Apple",
  "Apricot",
  "Avocado",
  "Banana",
  "Blackberry",
  "Blueberry",
  "Cherry",
  "Grape",
  "Lemon",
  "Mango",
  "Orange",
  "Peach",
  "Pear",
  "Pineapple",
  "Strawberry",
]

<template>
  <Autocomplete @defaultValue="Mango" as |c|>
    <div data-slot="stack">
      <c.Label>Fruit</c.Label>
      <div data-slot="row">
        <c.Input />
        <c.Clear aria-label="Clear">{{icon X}}</c.Clear>
        <c.Trigger aria-label="Show fruits">{{icon ChevronDown}}</c.Trigger>
      </div>
    </div>
    <c.Content>
      <c.Empty>No fruits found.</c.Empty>
      <c.List>
        {{#each fruits key="@identity" as |fruit|}}
          <c.Item @value={{fruit}}>
            {{fruit}}
          </c.Item>
        {{/each}}
      </c.List>
    </c.Content>
  </Autocomplete>
</template>
