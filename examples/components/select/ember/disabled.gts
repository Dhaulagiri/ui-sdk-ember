import { Check, ChevronDown } from "lucide"
import { Field } from "ember-ui-sdk/field"
import { Select } from "ember-ui-sdk/select"
import { icon } from "../../../shared/ember/icon"

const countries = [
  { value: "ca", label: "Canada" },
  { value: "dk", label: "Denmark" },
  { value: "fr", label: "France" },
  { value: "de", label: "Germany" },
  { value: "jp", label: "Japan" },
  { value: "es", label: "Spain" },
]

const fields = [
  { label: "Billing country", disabled: true, readOnly: false },
  { label: "Shipping from", disabled: false, readOnly: true },
  { label: "Shipping to", disabled: false, readOnly: false },
]

const initial = (field: { disabled: boolean; readOnly: boolean }) =>
  field.disabled || field.readOnly ? "fr" : null

const isDenmark = (value: string) => value === "dk"

<template>
  <div data-slot="stack">
    {{#each fields key="label" as |field|}}
      <Field as |f|>
        <f.Label>{{field.label}}</f.Label>
        <Select
          @defaultValue={{initial field}}
          @placeholder="Select a country"
          @disabled={{field.disabled}}
          @readOnly={{field.readOnly}}
          as |s|
        >
          <s.Trigger @field={{f.field}}>
            <s.Value />
            {{icon ChevronDown}}
          </s.Trigger>
          <s.Content>
            {{#each countries key="value" as |country|}}
              <s.Item
                @value={{country.value}}
                @disabled={{isDenmark country.value}}
                as |item|
              >
                {{country.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
      </Field>
    {{/each}}
  </div>
</template>
