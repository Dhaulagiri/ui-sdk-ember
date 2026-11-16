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
  <Autocomplete @autoHighlight={{true}} @loop={{false}} as |c|>
    <div data-slot="stack">
      <c.Label>Fruit</c.Label>
      <c.Input placeholder="Type, then Enter" />
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
