import { Tabs } from "ember-ui-sdk/tabs"

<template>
  <Tabs @defaultValue="general" @orientation="vertical" as |t|>
    <t.List aria-label="Preferences">
      <t.Tab @value="general">General</t.Tab>
      <t.Tab @value="security">Security</t.Tab>
      <t.Tab @value="integrations">Integrations</t.Tab>
    </t.List>
    <t.Panel @value="general">Choose your language, time zone and the page you
      start on.</t.Panel>
    <t.Panel @value="security">Manage passkeys, signed-in sessions and recovery
      codes.</t.Panel>
    <t.Panel @value="integrations">Connect your calendar and chat apps to get
      reminders.</t.Panel>
  </Tabs>
</template>
