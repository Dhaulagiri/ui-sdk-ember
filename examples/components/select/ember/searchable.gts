import { Check, ChevronDown } from "lucide"
import { Field } from "ember-ui-sdk/field"
import { Select } from "ember-ui-sdk/select"
import { icon } from "../../../shared/ember/icon"

const countries = [
  { value: "ar", label: "Argentina", code: "+54" },
  { value: "au", label: "Australia", code: "+61" },
  { value: "at", label: "Austria", code: "+43" },
  { value: "be", label: "Belgium", code: "+32" },
  { value: "br", label: "Brazil", code: "+55" },
  { value: "ca", label: "Canada", code: "+1" },
  { value: "cl", label: "Chile", code: "+56" },
  { value: "cn", label: "China", code: "+86" },
  { value: "dk", label: "Denmark", code: "+45" },
  { value: "fi", label: "Finland", code: "+358" },
  { value: "fr", label: "France", code: "+33" },
  { value: "de", label: "Germany", code: "+49" },
  { value: "gr", label: "Greece", code: "+30" },
  { value: "in", label: "India", code: "+91" },
  { value: "ie", label: "Ireland", code: "+353" },
  { value: "it", label: "Italy", code: "+39" },
  { value: "jp", label: "Japan", code: "+81" },
  { value: "mx", label: "Mexico", code: "+52" },
  { value: "nl", label: "Netherlands", code: "+31" },
  { value: "no", label: "Norway", code: "+47" },
  { value: "pt", label: "Portugal", code: "+351" },
  { value: "es", label: "Spain", code: "+34" },
  { value: "se", label: "Sweden", code: "+46" },
  { value: "ch", label: "Switzerland", code: "+41" },
]

const popularCountries = [
  {
    type: "group",
    label: "Popular",
    items: [countries[5], countries[11], countries[16]],
  },
]

const announcement = (change: { type: string; count?: number }) =>
  change.type === "results"
    ? `${change.count} ${change.count === 1 ? "country" : "countries"} found`
    : null

<template>
  <Field as |f|>
    <f.Label>Country</f.Label>
    <Select
      @items={{countries}}
      @emptyItems={{popularCountries}}
      @placeholder="Select a country"
      @filter="contains"
      @announcement={{announcement}}
      as |s|
    >
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
        <s.List as |list|>
          {{#each list.state.items key="@identity" as |entry|}}
            {{#if entry.items}}
              <s.Group as |g|>
                <g.Label>{{entry.label}}</g.Label>
                {{#each entry.items key="value" as |country|}}
                  <g.Item
                    @value={{country.value}}
                    @label={{country.label}}
                    as |item|
                  >
                    <item.Text />
                    <item.Indicator>{{icon Check}}</item.Indicator>
                  </g.Item>
                {{/each}}
              </s.Group>
            {{else}}
              <s.Item @value={{entry.value}} @label={{entry.label}} as |item|>
                <item.Text />
                <item.Indicator>{{icon Check}}</item.Indicator>
              </s.Item>
            {{/if}}
          {{/each}}
        </s.List>
      </s.Content>
    </Select>
  </Field>
</template>
