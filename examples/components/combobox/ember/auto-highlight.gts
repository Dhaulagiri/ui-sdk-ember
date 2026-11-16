import { Check, ChevronDown } from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "../../../shared/ember/icon"

const countries = [
  { value: "ar", label: "Argentina" },
  { value: "au", label: "Australia" },
  { value: "at", label: "Austria" },
  { value: "be", label: "Belgium" },
  { value: "br", label: "Brazil" },
  { value: "ca", label: "Canada" },
  { value: "cl", label: "Chile" },
  { value: "dk", label: "Denmark" },
  { value: "fi", label: "Finland" },
  { value: "fr", label: "France" },
  { value: "de", label: "Germany" },
  { value: "gr", label: "Greece" },
  { value: "jp", label: "Japan" },
  { value: "nl", label: "Netherlands" },
  { value: "es", label: "Spain" },
  { value: "se", label: "Sweden" },
  { value: "ch", label: "Switzerland" },
]

<template>
  <Combobox @autoHighlight={{true}} as |c|>
    <div data-slot="stack">
      <c.Label>Country</c.Label>
      <div data-slot="row">
        <c.Input placeholder="Type “sw” and press Enter" />
        <c.Trigger aria-label="Show countries">{{icon ChevronDown}}</c.Trigger>
      </div>
    </div>
    <c.Content>
      <c.Empty>No countries found.</c.Empty>
      <c.List>
        {{#each countries key="value" as |country|}}
          <c.Item @value={{country.value}} @label={{country.label}} as |item|>
            {{country.label}}
            <item.Indicator>{{icon Check}}</item.Indicator>
          </c.Item>
        {{/each}}
      </c.List>
    </c.Content>
  </Combobox>
</template>
