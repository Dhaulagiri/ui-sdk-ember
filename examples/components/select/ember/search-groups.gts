import { Check, ChevronDown } from "lucide"
import { Field } from "ember-ui-sdk/field"
import { Select } from "ember-ui-sdk/select"
import { icon } from "../../../shared/ember/icon"

const regions = [
  {
    label: "Americas",
    items: [
      { value: "br", label: "Brazil" },
      { value: "ca", label: "Canada" },
      { value: "mx", label: "Mexico" },
    ],
  },
  {
    label: "Europe",
    items: [
      { value: "fr", label: "France" },
      { value: "de", label: "Germany" },
      { value: "es", label: "Spain" },
    ],
  },
  {
    label: "Asia Pacific",
    items: [
      { value: "au", label: "Australia" },
      { value: "jp", label: "Japan" },
      { value: "sg", label: "Singapore" },
    ],
  },
]

<template>
  <Field as |f|>
    <f.Label>Country</f.Label>
    <Select @placeholder="Select a country" as |s|>
      <s.Trigger @field={{f.field}}>
        <s.Value />
        {{icon ChevronDown}}
      </s.Trigger>
      <s.Content>
        <s.Input
          aria-label="Search countries"
          placeholder="Search countries…"
        />
        <s.Empty>No countries found.</s.Empty>
        <s.List>
          {{#each regions key="label" as |region|}}
            <s.Group as |group|>
              <group.Label>{{region.label}}</group.Label>
              {{#each region.items key="value" as |country|}}
                <group.Item
                  @value={{country.value}}
                  @label={{country.label}}
                  as |item|
                >
                  <item.Text>{{country.label}}</item.Text>
                  <item.Indicator>{{icon Check}}</item.Indicator>
                </group.Item>
              {{/each}}
            </s.Group>
          {{/each}}
        </s.List>
      </s.Content>
    </Select>
  </Field>
</template>
