import { Check, ChevronDown } from "lucide"
import { Field } from "ember-ui-sdk/field"
import { Select } from "ember-ui-sdk/select"
import { icon } from "../../../shared/ember/icon"

const statuses = [
  { value: "backlog", label: "Backlog" },
  { value: "todo", label: "Todo" },
  { value: "in-progress", label: "In Progress" },
  { value: "in-review", label: "In Review" },
  { value: "done", label: "Done" },
]

<template>
  <Field as |f|>
    <f.Label>Status</f.Label>
    <Select @defaultValue="todo" @presentation="sheet" as |s|>
      <s.Trigger @field={{f.field}}>
        <s.Value />
        {{icon ChevronDown}}
      </s.Trigger>
      <s.Content>
        {{#each statuses key="value" as |status|}}
          <s.Item @value={{status.value}} as |item|>
            {{status.label}}
            <item.Indicator>{{icon Check}}</item.Indicator>
          </s.Item>
        {{/each}}
      </s.Content>
    </Select>
  </Field>
</template>
