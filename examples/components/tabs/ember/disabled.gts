import { Tabs } from "ember-ui-sdk/tabs"

<template>
  <Tabs @defaultValue="overview" as |t|>
    <t.List aria-label="Dashboard">
      <t.Tab @value="overview">Overview</t.Tab>
      <t.Tab @value="analytics">Analytics</t.Tab>
      <t.Tab @value="reports" @disabled={{true}}>Reports</t.Tab>
    </t.List>
    <t.Panel @value="overview">Revenue, visitors and sign-ups for the last 30
      days.</t.Panel>
    <t.Panel @value="analytics">Where your visitors come from and the pages they
      read most.</t.Panel>
    <t.Panel @value="reports">Monthly reports are available on the Pro plan.</t.Panel>
  </Tabs>
</template>
