import { array } from "@ember/helper"
import { CheckboxGroup } from "ember-ui-sdk/checkbox"
import { Check, Minus } from "lucide"
import { icon } from "../../../shared/ember/icon"

const toppings = [
  { value: "cheese", label: "Cheese" },
  { value: "mushrooms", label: "Mushrooms" },
  { value: "olives", label: "Olives" },
  { value: "peppers", label: "Peppers" },
]

const toppingValues = toppings.map((topping) => topping.value)

<template>
  <div data-slot="stack">
    <h3 id="parent-toppings">Toppings</h3>
    <CheckboxGroup
      @defaultValue={{array "cheese" "olives"}}
      @allValues={{toppingValues}}
      aria-labelledby="parent-toppings"
      as |g|
    >
      <label data-slot="label">
        <g.Checkbox @parent={{true}} as |c|>
          <c.Indicator>
            {{icon Check}}
            {{icon Minus}}
          </c.Indicator>
        </g.Checkbox>
        Select all
      </label>
      <div data-slot="stack">
        {{#each toppings key="value" as |topping|}}
          <label data-slot="label">
            <g.Checkbox @value={{topping.value}} as |c|>
              <c.Indicator>{{icon Check}}</c.Indicator>
            </g.Checkbox>
            {{topping.label}}
          </label>
        {{/each}}
      </div>
    </CheckboxGroup>
  </div>
</template>
