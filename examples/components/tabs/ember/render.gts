import { Tabs } from "ember-ui-sdk/tabs"

const folders = [
  {
    value: "inbox",
    label: "Inbox",
    count: 12,
    content: "12 conversations, 3 of them unread.",
  },
  {
    value: "unread",
    label: "Unread",
    count: 3,
    content: "Hollis Grant, Inès Moreau and Kofi Mensah wrote to you.",
  },
  {
    value: "archived",
    label: "Archived",
    count: 0,
    content: "Nothing archived yet. Archived mail stays searchable.",
  },
]

<template>
  <Tabs @defaultValue="inbox" as |t|>
    <t.List aria-label="Mail">
      {{#each folders key="value" as |folder|}}
        <t.Tab @value={{folder.value}} @render={{true}} as |tab|>
          <button type="button" {{tab.part}}>
            {{folder.label}}
            {{#if folder.count}}
              <span data-slot="badge">{{folder.count}}</span>
            {{/if}}
          </button>
        </t.Tab>
      {{/each}}
    </t.List>
    {{#each folders key="value" as |folder|}}
      <t.Panel @value={{folder.value}}>{{folder.content}}</t.Panel>
    {{/each}}
  </Tabs>
</template>
