import { array } from "@ember/helper"
import { CheckboxGroup } from "ember-ui-sdk/checkbox"
import { Check } from "lucide"
import { icon } from "../../../shared/ember/icon"

const toppings = [
  { value: "cheese", label: "جبن" },
  { value: "mushrooms", label: "فطر" },
  { value: "olives", label: "زيتون" },
  { value: "peppers", label: "فلفل" },
]

<template>
  <div data-slot="stack" dir="rtl">
    <h3 id="rtl-toppings">الإضافات</h3>
    <CheckboxGroup
      @defaultValue={{array "cheese"}}
      aria-labelledby="rtl-toppings"
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
