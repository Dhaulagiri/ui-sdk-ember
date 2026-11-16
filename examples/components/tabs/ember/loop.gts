import { Tabs } from "ember-ui-sdk/tabs"

const ranges = [
  {
    value: "day",
    label: "Day",
    content: "128 visitors today, up 12% from yesterday.",
  },
  {
    value: "week",
    label: "Week",
    content: "1,024 visitors this week, up 8% from last week.",
  },
  {
    value: "month",
    label: "Month",
    content: "4,210 visitors this month, down 3% from last month.",
  },
  {
    value: "year",
    label: "Year",
    content: "48,930 visitors this year, up 21% from last year.",
  },
]

<template>
  <Tabs @defaultValue="day" @loop={{false}} as |t|>
    <t.List aria-label="Range">
      {{#each ranges key="value" as |range|}}
        <t.Tab @value={{range.value}}>{{range.label}}</t.Tab>
      {{/each}}
    </t.List>
    {{#each ranges key="value" as |range|}}
      <t.Panel @value={{range.value}}>{{range.content}}</t.Panel>
    {{/each}}
  </Tabs>
</template>
