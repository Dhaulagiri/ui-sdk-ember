import { Menubar } from "ember-ui-sdk/menubar"

const labels = ["Inbox", "Drafts", "Archive"]

<template>
  <Menubar @orientation="vertical" as |mb|>
    {{#each labels key="@identity" as |label|}}
      <mb.Menu as |m|>
        <m.Trigger>{{label}}</m.Trigger>
        <m.Content>
          <m.Item>Open {{label}}</m.Item>
          <m.Item>Mark all as read</m.Item>
        </m.Content>
      </mb.Menu>
    {{/each}}
  </Menubar>
</template>
