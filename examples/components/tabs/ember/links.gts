import { Tabs } from "ember-ui-sdk/tabs"

const pages = [
  {
    value: "overview",
    href: "#project-overview",
    label: "Overview",
    content:
      "Hollis Grant started this project in March. It has 14 open issues.",
  },
  {
    value: "activity",
    href: "#project-activity",
    label: "Activity",
    content:
      "Wren Takahashi merged 3 pull requests and closed 5 issues this week.",
  },
  {
    value: "members",
    href: "#project-members",
    label: "Members",
    content:
      "Hollis Grant owns the project. Wren Takahashi and 3 others can edit it.",
  },
]

<template>
  <Tabs @defaultValue="overview" as |t|>
    <t.List aria-label="Project">
      {{#each pages key="value" as |page|}}
        <t.Tab @value={{page.value}} @render={{true}} as |tab|>
          <a href={{page.href}} {{tab.part}}>{{page.label}}</a>
        </t.Tab>
      {{/each}}
      <t.Indicator />
    </t.List>
    {{#each pages key="value" as |page|}}
      <t.Panel @value={{page.value}}>{{page.content}}</t.Panel>
    {{/each}}
  </Tabs>
</template>
