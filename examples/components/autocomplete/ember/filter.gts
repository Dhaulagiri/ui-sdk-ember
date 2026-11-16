import { get } from "@ember/helper"
import { Autocomplete } from "ember-ui-sdk/autocomplete"

const tags = [
  {
    value: "feature",
    label: "feature",
    keywords: ["enhancement", "request"],
  },
  { value: "fix", label: "fix", keywords: ["bug", "patch"] },
  { value: "docs", label: "docs", keywords: ["documentation", "readme"] },
  { value: "performance", label: "performance", keywords: ["speed", "slow"] },
  { value: "security", label: "security", keywords: ["vulnerability"] },
  { value: "refactor", label: "refactor", keywords: ["cleanup"] },
]

<template>
  <Autocomplete @filter="startsWith" as |c|>
    <div data-slot="stack">
      <c.Label>Tag</c.Label>
      <c.Input placeholder="Try “bug”" />
    </div>
    <c.Content>
      <c.Empty>No tags found.</c.Empty>
      <c.List>
        {{#each tags key="value" as |tag|}}
          <c.Item
            @value={{tag.value}}
            @label={{tag.label}}
            @keywords={{tag.keywords}}
          >
            {{tag.label}}
            <span data-slot="hint">{{get tag.keywords 0}}</span>
          </c.Item>
        {{/each}}
      </c.List>
    </c.Content>
  </Autocomplete>
</template>
