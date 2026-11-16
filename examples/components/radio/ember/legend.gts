import { FieldSet } from "ember-ui-sdk/field"
import { RadioGroup } from "ember-ui-sdk/radio"

const periods = [
  { value: "monthly", label: "Monthly", price: "$12 per month" },
  { value: "yearly", label: "Yearly", price: "$120 per year" },
]

<template>
  <FieldSet as |s|>
    <s.Legend id="billing-legend">Billing period</s.Legend>
    <s.Description id="billing-description">Yearly billing gets you two months
      free.</s.Description>
    <RadioGroup
      @defaultValue="monthly"
      aria-labelledby="billing-legend"
      aria-describedby="billing-description"
      as |g|
    >
      {{#each periods key="value" as |period|}}
        <label data-slot="label">
          <g.Radio @value={{period.value}} as |r|>
            <r.Indicator />
          </g.Radio>
          {{period.label}}
          <span data-slot="hint">({{period.price}})</span>
        </label>
      {{/each}}
    </RadioGroup>
  </FieldSet>
</template>
