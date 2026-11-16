import { Check, ChevronDown } from "lucide"
import { Field } from "ember-ui-sdk/field"
import { Select } from "ember-ui-sdk/select"
import { icon } from "../../../shared/ember/icon"

const sizeGroups = [
  { type: "group", label: "Common", items: ["Small", "Medium", "Large"] },
  { type: "group", label: "Extended", items: ["Extra small", "Extra large"] },
]

<template>
  <Field as |f|>
    <f.Label>Size</f.Label>
    <Select @items={{sizeGroups}} @name="size" @defaultValue="Medium" as |s|>
      <s.Trigger @field={{f.field}}>
        <s.Value />
        {{icon ChevronDown}}
      </s.Trigger>
      <s.Content>
        {{#each sizeGroups key="label" as |group|}}
          <s.Group as |g|>
            <g.Label>{{group.label}}</g.Label>
            {{#each group.items key="@identity" as |size|}}
              <g.Item @value={{size}} as |item|>
                {{size}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </g.Item>
            {{/each}}
          </s.Group>
        {{/each}}
      </s.Content>
    </Select>
  </Field>
</template>
