import { array, get } from "@ember/helper"
import { Check, Minus, X } from "lucide"
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

const groupSelectAllLabel = (checked: boolean, label: string) =>
  checked ? `Clear ${label}` : `Select all in ${label}`

<template>
  <Combobox @multiple={{true}} @defaultValue={{array "Europe/Paris"}} as |c|>
    <div data-slot="stack">
      <c.Label>Timezones</c.Label>
      <c.Chips>
        <c.Value as |state|>
          {{#each state.value key="@identity" as |value index|}}
            <c.Chip @value={{value}} as |chip|>
              {{get state.labels index}}
              <chip.Remove aria-label="Remove {{get state.labels index}}">{{icon
                  X
                }}</chip.Remove>
            </c.Chip>
          {{/each}}
        </c.Value>
        <c.Input placeholder="Add timezones…" />
      </c.Chips>
    </div>
    <c.Content>
      <c.Empty>No timezones found.</c.Empty>
      <c.List>
        <c.SelectAll>
          <span>
            {{icon Check}}
            {{icon Minus}}
          </span>
          Select all
        </c.SelectAll>
        {{#each timezones key="label" as |group|}}
          <c.Group as |g|>
            <g.Label>
              {{group.label}}
            </g.Label>
            <g.SelectAll as |sa|>
              {{groupSelectAllLabel sa.state.checked group.label}}
            </g.SelectAll>
            {{#each group.items key="value" as |zone|}}
              <g.Item @value={{zone.value}} @label={{zone.label}} as |item|>
                <span>
                  <item.Indicator>{{icon Check}}</item.Indicator>
                </span>
                {{zone.label}}
              </g.Item>
            {{/each}}
          </c.Group>
        {{/each}}
      </c.List>
    </c.Content>
  </Combobox>
</template>
