import { Autocomplete } from "ember-ui-sdk/autocomplete"

const recent = ["react hooks", "tailwind grid", "web components", "vue v-model"]

<template>
  <Autocomplete @openOnFocus={{true}} as |c|>
    <c.Input aria-label="Search" placeholder="Search…" />
    <c.Content>
      <c.Empty>No results.</c.Empty>
      <c.List>
        <c.Group as |g|>
          <g.Label>Recent searches</g.Label>
          {{#each recent key="@identity" as |search|}}
            <g.Item @value={{search}}>
              {{search}}
            </g.Item>
          {{/each}}
        </c.Group>
      </c.List>
    </c.Content>
  </Autocomplete>
</template>
