import { Check, ChevronDown } from "lucide"
import { Field } from "ember-ui-sdk/field"
import { Select } from "ember-ui-sdk/select"
import { icon } from "../../../shared/ember/icon"
import type { ListData } from "ember-ui-sdk/select"

const plans = [
  { value: "free", label: "Free" },
  { value: "pro", label: "Pro" },
  { value: "team", label: "Team" },
]

const sales = [
  { value: "enterprise", label: "Enterprise" },
  { value: "education", label: "Education", disabled: true },
]

const items: ListData = [
  ...plans,
  { type: "separator" },
  { type: "group", label: "Contact sales", items: sales },
]

<template>
  <Field as |f|>
    <f.Label>Plan</f.Label>
    <Select @items={{items}} @defaultValue="pro" as |s|>
      <s.Trigger @field={{f.field}}>
        <s.Value />
        {{icon ChevronDown}}
      </s.Trigger>
      <s.Content>
        {{#each plans key="value" as |plan|}}
          <s.Item @value={{plan.value}} as |item|>
            {{plan.label}}
            <item.Indicator>{{icon Check}}</item.Indicator>
          </s.Item>
        {{/each}}
        <s.Separator />
        <s.Group as |group|>
          <group.Label>Contact sales</group.Label>
          {{#each sales key="value" as |plan|}}
            <group.Item
              @value={{plan.value}}
              @disabled={{plan.disabled}}
              as |item|
            >
              {{plan.label}}
              <item.Indicator>{{icon Check}}</item.Indicator>
            </group.Item>
          {{/each}}
        </s.Group>
      </s.Content>
    </Select>
  </Field>
</template>
