import { Check, ChevronDown } from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "../../../shared/ember/icon"

const countries = [
  { value: "ar", label: "Argentina", keywords: ["república argentina"] },
  { value: "au", label: "Australia", keywords: ["oz"] },
  { value: "at", label: "Austria", keywords: ["österreich"] },
  { value: "be", label: "Belgium", keywords: ["belgië", "belgique"] },
  { value: "br", label: "Brazil", keywords: ["brasil"] },
  { value: "ca", label: "Canada" },
  { value: "cl", label: "Chile" },
  { value: "dk", label: "Denmark", keywords: ["danmark"] },
  { value: "fi", label: "Finland", keywords: ["suomi"] },
  { value: "fr", label: "France" },
  { value: "de", label: "Germany", keywords: ["deutschland"] },
  { value: "gr", label: "Greece", keywords: ["hellas", "ελλάδα"] },
  { value: "jp", label: "Japan", keywords: ["nippon", "日本"] },
  { value: "nl", label: "Netherlands", keywords: ["holland", "nederland"] },
  { value: "es", label: "Spain", keywords: ["españa"] },
  { value: "se", label: "Sweden", keywords: ["sverige"] },
  {
    value: "ch",
    label: "Switzerland",
    keywords: ["schweiz", "suisse", "svizzera"],
  },
]

const recentCountries = [
  {
    type: "group",
    label: "Recent",
    items: [countries[9], countries[12], countries[15]],
  },
]

const announcement = (change: { type: string; count?: number }) =>
  change.type === "results" ? `${change.count} countries match` : null

<template>
  <Combobox
    @items={{countries}}
    @emptyItems={{recentCountries}}
    @announcement={{announcement}}
    as |c|
  >
    <div data-slot="stack">
      <c.Label>Country</c.Label>
      <div data-slot="row">
        <c.Input placeholder="Search countries…" />
        <c.Trigger aria-label="Show countries">{{icon ChevronDown}}</c.Trigger>
      </div>
    </div>
    <c.Content>
      <c.Empty>No countries found.</c.Empty>
      <c.List as |list|>
        {{#each list.state.items key="@identity" as |entry|}}
          {{#if entry.items}}
            <c.Group as |g|>
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
            </c.Group>
          {{else}}
            <c.Item @value={{entry.value}} @label={{entry.label}} as |item|>
              <item.Text />
              <item.Indicator>{{icon Check}}</item.Indicator>
            </c.Item>
          {{/if}}
        {{/each}}
      </c.List>
    </c.Content>
  </Combobox>
</template>
