import { Autocomplete } from "ember-ui-sdk/autocomplete"

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
  <Autocomplete as |c|>
    <div data-slot="stack">
      <c.Label>Favorite fruit</c.Label>
      <c.Input placeholder="e.g. berry" />
    </div>
    <c.Content>
      <c.Empty>No fruits found.</c.Empty>
      <c.List>
        {{#each fruits key="@identity" as |fruit|}}
          <c.Item @value={{fruit}} as |item|>
            <item.Text />
          </c.Item>
        {{/each}}
      </c.List>
    </c.Content>
  </Autocomplete>
</template>
