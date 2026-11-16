import { Autocomplete } from "ember-ui-sdk/autocomplete"

const fruitGroups = [
  {
    label: "Tree fruits",
    fruits: ["Apple", "Apricot", "Cherry", "Lemon", "Peach", "Pear"],
  },
  {
    label: "Berries",
    fruits: ["Blackberry", "Blueberry", "Grape", "Strawberry"],
  },
  { label: "Tropical", fruits: ["Avocado", "Banana", "Mango", "Pineapple"] },
]

const isFirst = (index: number) => index === 0

<template>
  <Autocomplete as |c|>
    <div data-slot="stack">
      <c.Label>Fruit</c.Label>
      <c.Input placeholder="e.g. Peach" />
    </div>
    <c.Content>
      <c.Empty>No fruits found.</c.Empty>
      <c.List>
        {{#each fruitGroups key="label" as |group index|}}
          {{#unless (isFirst index)}}
            <c.Separator />
          {{/unless}}
          <c.Group as |g|>
            <g.Label>{{group.label}}</g.Label>
            {{#each group.fruits key="@identity" as |fruit|}}
              <g.Item @value={{fruit}}>{{fruit}}</g.Item>
            {{/each}}
          </c.Group>
        {{/each}}
      </c.List>
    </c.Content>
  </Autocomplete>
</template>
