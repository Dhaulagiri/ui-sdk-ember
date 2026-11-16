import { Check, ChevronDown } from "lucide"
import { Field } from "ember-ui-sdk/field"
import { Select } from "ember-ui-sdk/select"
import { icon } from "../../../shared/ember/icon"

const sizes = ["Extra small", "Small", "Medium", "Large", "Extra large"]
const wraps = ["Paper", "Ribbon", "Box"]

<template>
  <div data-slot="stack">
    <Field as |f|>
      <f.Label>Size</f.Label>
      <Select @placeholder="Select a size" as |s|>
        <s.Trigger @field={{f.field}}>
          <s.Value />
          {{icon ChevronDown}}
        </s.Trigger>
        <s.Content>
          {{#each sizes key="@identity" as |size|}}
            <s.Item @value={{size}} as |item|>
              {{size}}
              <item.Indicator>{{icon Check}}</item.Indicator>
            </s.Item>
          {{/each}}
        </s.Content>
      </Select>
    </Field>
    <Field as |f|>
      <f.Label>Gift wrap</f.Label>
      <Select as |s|>
        <s.Trigger @field={{f.field}}>
          <s.Value @placeholder="None" />
          {{icon ChevronDown}}
        </s.Trigger>
        <s.Content>
          {{#each wraps key="@identity" as |wrap|}}
            <s.Item @value={{wrap}} as |item|>
              {{wrap}}
              <item.Indicator>{{icon Check}}</item.Indicator>
            </s.Item>
          {{/each}}
        </s.Content>
      </Select>
    </Field>
  </div>
</template>
