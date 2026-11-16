import { array } from "@ember/helper"
import { ToggleGroup } from "ember-ui-sdk/toggle"

const views = [
  { value: "list", label: "قائمة" },
  { value: "grid", label: "شبكة" },
  { value: "cards", label: "بطاقات" },
]

<template>
  <div dir="rtl">
    <ToggleGroup @defaultValue={{array "list"}} aria-label="العرض" as |g|>
      {{#each views key="value" as |item|}}
        <g.Toggle @value={{item.value}}>
          {{item.label}}
        </g.Toggle>
      {{/each}}
    </ToggleGroup>
  </div>
</template>
