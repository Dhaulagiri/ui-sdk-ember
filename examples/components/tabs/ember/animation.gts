import { Tabs } from "ember-ui-sdk/tabs"

<template>
  <Tabs @defaultValue="overview" as |t|>
    <t.List aria-label="Project">
      <t.Tab @value="overview">Overview</t.Tab>
      <t.Tab @value="activity">Activity</t.Tab>
      <t.Tab @value="settings">Settings</t.Tab>
      <t.Indicator />
    </t.List>
    <div data-slot="stack">
      <t.Panel @value="overview">The launch is on track for Friday, with 4 of 6
        tasks done.</t.Panel>
      <t.Panel @value="activity">
        Inès Moreau deployed to production and Kofi Mensah left a review.
      </t.Panel>
      <t.Panel @value="settings">Rename the project, transfer it to another team
        or archive it.</t.Panel>
    </div>
  </Tabs>
</template>
