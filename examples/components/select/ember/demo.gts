import { Check, ChevronDown } from "lucide"
import { Field } from "ember-ui-sdk/field"
import { Select } from "ember-ui-sdk/select"
import { icon } from "../../../shared/ember/icon"

const roles = [
  { value: "viewer", label: "Viewer" },
  { value: "commenter", label: "Commenter" },
  { value: "editor", label: "Editor" },
  { value: "admin", label: "Admin" },
]

<template>
  <Field as |f|>
    <f.Label>Role</f.Label>
    <Select @placeholder="Select a role" as |s|>
      <s.Trigger @field={{f.field}}>
        <s.Value />
        {{icon ChevronDown}}
      </s.Trigger>
      <s.Content>
        {{#each roles key="value" as |role|}}
          <s.Item @value={{role.value}} as |item|>
            {{role.label}}
            <item.Indicator>{{icon Check}}</item.Indicator>
          </s.Item>
        {{/each}}
      </s.Content>
    </Select>
  </Field>
</template>
