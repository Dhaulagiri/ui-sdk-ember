import { Tabs } from "ember-ui-sdk/tabs"

<template>
  <Tabs @defaultValue="account" as |t|>
    <t.List aria-label="Settings">
      <t.Tab @value="account">Account</t.Tab>
      <t.Tab @value="password">Password</t.Tab>
    </t.List>
    <t.Panel @value="account">
      Update your name, email address and profile photo. Your team sees changes
      right away.
    </t.Panel>
    <t.Panel @value="password">
      Choose a new password for hollis@example.com. You stay signed in on this
      device.
    </t.Panel>
  </Tabs>
</template>
