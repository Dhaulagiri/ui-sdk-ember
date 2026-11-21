import { Check, ChevronDown } from "lucide"
import { Field } from "ember-ui-sdk/field"
import { Select } from "ember-ui-sdk/select"
import { icon } from "../../../shared/ember/icon"

const priorities = [
  { value: "urgent", label: "Urgent" },
  { value: "high", label: "High" },
  { value: "medium", label: "Medium" },
  { value: "low", label: "Low" },
  { value: "none", label: "No priority" },
]

<template>
  <Field as |f|>
    <f.Label>Priority</f.Label>
    <Select @virtualFocus={{true}} @defaultValue="none" as |s|>
      <s.Trigger @field={{f.field}}>
        <s.Value />
        {{icon ChevronDown}}
      </s.Trigger>
      <s.Content>
        {{#each priorities key="value" as |priority|}}
          <s.Item @value={{priority.value}} as |item|>
            {{priority.label}}
            <item.Indicator>{{icon Check}}</item.Indicator>
          </s.Item>
        {{/each}}
      </s.Content>
    </Select>
  </Field>
</template>
