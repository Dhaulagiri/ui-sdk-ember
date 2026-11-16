import { Check, ChevronDown } from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "../../../shared/ember/icon"

const timezones = [
  {
    label: "Americas",
    items: [
      { value: "America/New_York", label: "New York" },
      { value: "America/Chicago", label: "Chicago" },
      { value: "America/Denver", label: "Denver" },
      { value: "America/Los_Angeles", label: "Los Angeles" },
      { value: "America/Sao_Paulo", label: "São Paulo" },
    ],
  },
  {
    label: "Europe",
    items: [
      { value: "Europe/London", label: "London" },
      { value: "Europe/Paris", label: "Paris" },
      { value: "Europe/Berlin", label: "Berlin" },
      { value: "Europe/Madrid", label: "Madrid" },
    ],
  },
  {
    label: "Asia & Pacific",
    items: [
      { value: "Asia/Tokyo", label: "Tokyo" },
      { value: "Asia/Singapore", label: "Singapore" },
      { value: "Asia/Kolkata", label: "Kolkata" },
      { value: "Australia/Sydney", label: "Sydney" },
    ],
  },
]

const isFirst = (index: number) => index === 0

<template>
  <Combobox as |c|>
    <div data-slot="stack">
      <c.Label>Timezone</c.Label>
      <div data-slot="row">
        <c.Input placeholder="Search cities…" />
        <c.Trigger aria-label="Show timezones">{{icon ChevronDown}}</c.Trigger>
      </div>
    </div>
    <c.Content>
      <c.Empty>No cities found.</c.Empty>
      <c.List>
        {{#each timezones key="label" as |group index|}}
          {{#unless (isFirst index)}}
            <c.Separator />
          {{/unless}}
          <c.Group as |g|>
            <g.Label>
              {{group.label}}
            </g.Label>
            {{#each group.items key="value" as |item|}}
              <g.Item @value={{item.value}} @label={{item.label}} as |entry|>
                {{item.label}}
                <entry.Indicator>{{icon Check}}</entry.Indicator>
              </g.Item>
            {{/each}}
          </c.Group>
        {{/each}}
      </c.List>
    </c.Content>
  </Combobox>
</template>
