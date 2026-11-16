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

const skipped = (index: number) => index % 3 === 0

<template>
  <div data-slot="stack">
    <Autocomplete @disabled={{true}} @defaultValue="Banana" as |c|>
      <div data-slot="stack">
        <c.Label>Disabled</c.Label>
        <c.Input />
      </div>
    </Autocomplete>
    <Autocomplete @readOnly={{true}} @defaultValue="Cherry" as |c|>
      <div data-slot="stack">
        <c.Label>Read-only</c.Label>
        <c.Input />
      </div>
    </Autocomplete>
    <Autocomplete as |c|>
      <div data-slot="stack">
        <c.Label>Some suggestions disabled</c.Label>
        <c.Input placeholder="Type “b”" />
      </div>
      <c.Content>
        <c.List>
          {{#each fruits key="@identity" as |fruit index|}}
            <c.Item @value={{fruit}} @disabled={{(skipped index)}}>
              {{fruit}}
            </c.Item>
          {{/each}}
        </c.List>
      </c.Content>
    </Autocomplete>
  </div>
</template>
