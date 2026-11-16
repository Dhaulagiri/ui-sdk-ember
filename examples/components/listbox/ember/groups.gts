import { array } from "@ember/helper"
import { Listbox } from "ember-ui-sdk/listbox"
import { Check } from "lucide"
import { icon } from "../../../shared/ember/icon"

const produce = [
  {
    label: "Fruits",
    items: [
      { value: "apple", label: "Apple" },
      { value: "banana", label: "Banana" },
      { value: "orange", label: "Orange" },
    ],
  },
  {
    label: "Vegetables",
    items: [
      { value: "carrot", label: "Carrot" },
      { value: "broccoli", label: "Broccoli" },
      { value: "spinach", label: "Spinach" },
    ],
  },
]

<template>
  <Listbox
    @multiple={{true}}
    @defaultValue={{array "banana"}}
    aria-label="Produce"
    as |l|
  >
    {{#each produce key="label" as |group index|}}
      {{#if index}}
        <l.Separator />
      {{/if}}
      <l.Group as |g|>
        <g.Label>{{group.label}}</g.Label>
        {{#each group.items key="value" as |item|}}
          <g.Item @value={{item.value}} as |i|>
            {{item.label}}
            <i.Indicator>{{icon Check}}</i.Indicator>
          </g.Item>
        {{/each}}
      </l.Group>
    {{/each}}
  </Listbox>
</template>
