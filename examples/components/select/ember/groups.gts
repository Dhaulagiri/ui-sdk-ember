import { Check, ChevronDown } from "lucide"
import { Field } from "ember-ui-sdk/field"
import { Select } from "ember-ui-sdk/select"
import { icon } from "../../../shared/ember/icon"

const fonts = [
  {
    label: "Sans serif",
    items: [
      { value: "inter", label: "Inter" },
      { value: "geist", label: "Geist" },
    ],
  },
  {
    label: "Serif",
    items: [
      { value: "source-serif", label: "Source Serif" },
      { value: "lora", label: "Lora" },
    ],
  },
  {
    label: "Monospace",
    items: [
      { value: "geist-mono", label: "Geist Mono" },
      { value: "jetbrains-mono", label: "JetBrains Mono" },
    ],
  },
]

const isFirst = (index: number) => index === 0

<template>
  <Field as |f|>
    <f.Label>Font</f.Label>
    <Select @placeholder="Select a font" as |s|>
      <s.Trigger @field={{f.field}}>
        <s.Value />
        {{icon ChevronDown}}
      </s.Trigger>
      <s.Content>
        {{#each fonts key="label" as |font index|}}
          {{#unless (isFirst index)}}
            <s.Separator />
          {{/unless}}
          <s.Group as |group|>
            <group.Label>{{font.label}}</group.Label>
            {{#each font.items key="value" as |option|}}
              <group.Item @value={{option.value}} as |item|>
                {{option.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </group.Item>
            {{/each}}
          </s.Group>
        {{/each}}
      </s.Content>
    </Select>
  </Field>
</template>
