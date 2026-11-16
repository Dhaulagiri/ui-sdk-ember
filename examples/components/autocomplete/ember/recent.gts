import { Autocomplete } from "ember-ui-sdk/autocomplete"

const recent = ["react hooks", "tailwind grid", "web components", "vue v-model"]
const topics = [
  ...recent,
  "react server components",
  "tailwind colors",
  "vue router",
]
const recentSearches = [
  { type: "group", label: "Recent searches", items: recent },
]

const announcement = (change: { type: string; count?: number }) =>
  change.type === "results"
    ? `${change.count} ${change.count === 1 ? "topic" : "topics"}`
    : null

<template>
  <Autocomplete
    @items={{topics}}
    @emptyItems={{recentSearches}}
    @openOnFocus={{true}}
    @announcement={{announcement}}
    as |c|
  >
    <c.Input
      type="search"
      aria-label="Search docs"
      placeholder="Search docs…"
    />
    <c.Content>
      <c.Empty>No topics found.</c.Empty>
      <c.List as |list|>
        {{#each list.state.items key="@identity" as |entry|}}
          {{#if entry.items}}
            <c.Group as |g|>
              <g.Label>{{entry.label}}</g.Label>
              {{#each entry.items key="@identity" as |topic|}}
                <g.Item @value={{topic}} as |item|>
                  <item.Text />
                </g.Item>
              {{/each}}
            </c.Group>
          {{else}}
            <c.Item @value={{entry}} as |item|>
              <item.Text />
            </c.Item>
          {{/if}}
        {{/each}}
      </c.List>
    </c.Content>
  </Autocomplete>
</template>
