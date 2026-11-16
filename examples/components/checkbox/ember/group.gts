import { array } from "@ember/helper"
import { CheckboxGroup } from "ember-ui-sdk/checkbox"
import { Check } from "lucide"
import { icon } from "../../../shared/ember/icon"

const toppings = [
  { value: "cheese", label: "Cheese" },
  { value: "mushrooms", label: "Mushrooms" },
  { value: "olives", label: "Olives" },
  { value: "peppers", label: "Peppers" },
]

<template>
  <div data-slot="stack">
    <h3 id="basic-toppings">Toppings</h3>
    <CheckboxGroup
      @defaultValue={{array "cheese"}}
      aria-labelledby="basic-toppings"
      as |g|
    >
      {{#each toppings key="value" as |topping|}}
        <label data-slot="label">
          <g.Checkbox @value={{topping.value}} as |c|>
            <c.Indicator>{{icon Check}}</c.Indicator>
          </g.Checkbox>
          {{topping.label}}
        </label>
      {{/each}}
    </CheckboxGroup>
  </div>
</template>
