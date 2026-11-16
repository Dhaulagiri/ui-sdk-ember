import { Tabs } from "ember-ui-sdk/tabs"

<template>
  <Tabs @defaultValue="overview" as |t|>
    <t.List aria-label="Dashboard">
      <t.Tab @value="overview">Overview</t.Tab>
      <t.Tab @value="analytics">Analytics</t.Tab>
      <t.Tab @value="reports">Reports</t.Tab>
      <t.Indicator />
    </t.List>
    <t.Panel @value="overview">
      Revenue, visitors and sign-ups for the last 30 days.
    </t.Panel>
    <t.Panel @value="analytics">
      Where visitors come from and what they do.
    </t.Panel>
    <t.Panel @value="reports">Monthly reports, ready to download.</t.Panel>
  </Tabs>
</template>
